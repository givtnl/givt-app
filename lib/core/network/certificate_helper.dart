import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/failures/certificate_exception.dart';
import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/core/network/token_interceptor.dart';
import 'package:givt_app/shared/models/certificate_response.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:http/http.dart' as http;
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CertificateHelper {
  CertificateHelper();

  late SecureHttpClient _secureEuClient;
  late SecureHttpClient _secureUsClient;
  late Client euClient;
  late Client usClient;

  late String euBaseUrl;
  late String usBaseUrl;
  late String euBaseUrlAWS;
  late String usBaseUrlAWS;
  late String country;

  Client get client => country == Country.us.countryCode ? usClient : euClient;

  Future<void> init() async {
    euBaseUrl = const String.fromEnvironment('API_URL_EU');
    euBaseUrlAWS = const String.fromEnvironment('API_URL_AWS_EU');
    usBaseUrl = const String.fromEnvironment('API_URL_US');
    usBaseUrlAWS = const String.fromEnvironment('API_URL_AWS_US');
    await _createClients();
    country = await _checkCountry();
  }

  Future<void> _createClients() async {
    await _checkForAndroidTrustedCertificate();

    final euFuture = _getAllowedFingerprints(euBaseUrl, euBaseUrlAWS);
    final usFuture = _getAllowedFingerprints(usBaseUrl, usBaseUrlAWS);
    final allowedEUFingerprints = await euFuture;
    final allowedUSFingerprints = await usFuture;
    _secureEuClient = _getSecureClient(allowedEUFingerprints);
    _secureUsClient = _getSecureClient(allowedUSFingerprints);
    euClient = createClient(_secureEuClient);
    usClient = createClient(_secureUsClient);
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
    } catch (_) {}
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

  Client createClient(Client client) {
    return InterceptedClient.build(
      client: client,
      requestTimeout: const Duration(seconds: 30),
      interceptors: [
        TokenInterceptor(),
      ],
      retryPolicy: ExpiredTokenRetryPolicy(),
    );
  }

  Future<List<String>> _getAllowedFingerprints(
    String apiUrl,
    String apiUrlAws,
  ) async {
    try {
      final response = await _requestCerts(apiUrl, apiUrlAws);

      final publicKey =
          await rootBundle.loadString('assets/ca/certificatekey.txt');
      final jwtVerified = JWT.verify(response.token, RSAPublicKey(publicKey));

      final allowedFingerprints = [
        jwtVerified.payload[apiUrl].toString(),
        jwtVerified.payload[apiUrlAws].toString(),
      ];

      return allowedFingerprints;
    } on Exception catch (e) {
      throw CertificatesException(message: e.toString());
    }
  }

  Future<CertificateResponse> _requestCerts(
      String apiUrl, String apiUrlAws) async {
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
      apiURLAWS: apiUrlAws,
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
    final secureClient = SecureHttpClient.build(allowedSHAFingerprints);
    return secureClient;
  }
}
