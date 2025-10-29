import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/failures/certificate_exception.dart';
import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/core/network/certificate_check_interceptor.dart';
import 'package:givt_app/core/network/expired_token_retry_policy.dart';
import 'package:givt_app/core/network/family_expired_token_retry_policy.dart';
import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/shared/models/certificate_response.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:http/http.dart' as http;
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
Handles:
- Certificate checking
- Creating clients for EU and US
- Updating the base urls
*/
class RequestHelper {
  RequestHelper(
    this._networkInfo,
    this._sharedPreferences, {
    required String apiURL,
  })  : _apiURL = apiURL;

  final NetworkInfo _networkInfo;
  final SharedPreferences _sharedPreferences;
  StreamSubscription<bool>? _internetSubscription;

  late SecureHttpClient _secureEuClient;
  late SecureHttpClient _secureUsClient;
  late Client euClient;
  late Client usClient;

  late String euBaseUrl;
  late String usBaseUrl;
  late String country;

  Client get client => country == Country.us.countryCode ? usClient : euClient;

  String _apiURL;

  String get apiURL => _apiURL;

  void updateApiUrl(String url) {
    _apiURL = url;
  }

  Future<void> init() async {
    euBaseUrl = const String.fromEnvironment('API_URL_EU');
    usBaseUrl = const String.fromEnvironment('API_URL_US');
    await _createClients();
    country = await _checkCountry();
  }

  Future<void> _createClients() async {
    await _checkForAndroidTrustedCertificate();

    try {
      final euFuture = _getAllowedFingerprints(euBaseUrl);
      final usFuture = _getAllowedFingerprints(usBaseUrl);
      final allowedEUFingerprints = await euFuture;
      final allowedUSFingerprints = await usFuture;
      _secureEuClient = _getSecureClient(allowedEUFingerprints);
      _secureUsClient = _getSecureClient(allowedUSFingerprints);
      euClient = createEUClient(client: _secureEuClient);
      usClient = createUSClient(client: _secureUsClient);
    } catch (e, s) {
      if (_failedDueToInternetConnectionButWeHaveInternetNow(e)) {
        LoggingInfo.instance.info(
          '''
Error while setting up secure http clients (while having an internet connection): $e\n$s''',
        );
        await _createClients();
      } else {
        euClient = createEUClient();
        usClient = createUSClient();
        _internetSubscription =
            _networkInfo.hasInternetConnectionStream().listen(
          (hasConnection) async {
            if (hasConnection) {
              await _createClients();
              _internetSubscription?.cancel();
            }
          },
        );
      }
    }
  }

  bool _failedDueToInternetConnectionButWeHaveInternetNow(Object e) {
    return _networkInfo.isConnected &&
        (e is CertificatesException &&
            true == e.message?.toLowerCase().contains('socket'));
  }

  Future<void> _checkForAndroidTrustedCertificate() async {
    try {
      if (Platform.isAndroid) {
        final data =
            await PlatformAssetBundle().load('assets/ca/isrgrootx1.pem');
        SecurityContext.defaultContext.setTrustedCertificatesBytes(
          data.buffer.asUint8List(),
        );
      }
    } catch (e, s) {
      LoggingInfo.instance.info(
        'Android specific check for trusted certificate failed: $e\n$s',
      );
    }
  }

  /// Check if there is a user extension set in the shared preferences.
  /// If there is, return the country of the user extension.
  /// If there is not, return a default country (NL).
  Future<String> _checkCountry() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(UserExt.tag)) {
      final userExtString = prefs.getString(UserExt.tag);
      if (userExtString != null) {
        final user =
            UserExt.fromJson(jsonDecode(userExtString) as Map<String, dynamic>);
        return user.country;
      }
    }

    return Country.nl.countryCode;
  }

  Client createEUClient({Client? client}) {
    return InterceptedClient.build(
      client: client,
      requestTimeout: const Duration(seconds: 30),
      interceptors: [
        if (client == null) CertificateCheckInterceptor(),
        TokenInterceptor(),
      ],
      retryPolicy: ExpiredTokenRetryPolicy(),
    );
  }

  Client createUSClient({Client? client}) {
    return InterceptedClient.build(
      client: client,
      requestTimeout: const Duration(seconds: 30),
      interceptors: [
        if (client == null) CertificateCheckInterceptor(),
        TokenInterceptor(),
      ],
      retryPolicy: FamilyExpiredTokenRetryPolicy(),
    );
  }

  Future<List<String>> _getAllowedFingerprints(
    String apiUrl,
  ) async {
    try {
      final response = await _requestCerts(apiUrl);

      final publicKey =
          await rootBundle.loadString('assets/ca/certificatekey.txt');
      final jwtVerified = JWT.verify(response.token, RSAPublicKey(publicKey));

      final allowedFingerprints = [
        jwtVerified.payload[apiUrl].toString(),
      ];

      await _sharedPreferences.setString(
        response.apiURL,
        allowedFingerprints[0],
      );

      return allowedFingerprints;
    } on Exception catch (e) {
      throw CertificatesException(message: e.toString());
    }
  }

  Future<CertificateResponse> _requestCerts(
    String apiUrl,
  ) async {
    final url = _getCertsUrl(apiUrl);
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
    return CertificateResponse(
      token: response.body.trim().replaceAll('"', ''),
      apiURL: apiUrl,
    );
  }

  Uri _getCertsUrl(String apiUrl) {
    final isEu = apiUrl.contains('givtapp.net');
    final isDev = apiUrl.contains('dev');

    if (isDev) {
      if (isEu) {
        return Uri.https('dev-certs.givtapp.net', '/v1');
      }
      return Uri.https('dev-certs.givt.app', '/v1');
    } else if (isEu) {
      return Uri.https('certs.givtapp.net', '/v1');
    }
    return Uri.https('certs.givt.app', '/v1');
  }

  SecureHttpClient _getSecureClient(List<String> allowedSHAFingerprints) {
    return SecureHttpClient.build(allowedSHAFingerprints);
  }
}
