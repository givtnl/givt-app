import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class SecureHttpClient extends http.BaseClient {
  SecureHttpClient._internal(
      {required this.allowedSHAFingerprints, http.BaseClient? customClient}) {
    if (customClient != null) {
      _client = customClient;
    }
  }

  factory SecureHttpClient.build(List<String> allowedSHAFingerprints,
      {http.BaseClient? customClient}) {
    return SecureHttpClient._internal(
        allowedSHAFingerprints: allowedSHAFingerprints,
        customClient: customClient);
  }
  List<String> allowedSHAFingerprints;

  http.BaseClient _client = IOClient();

  Future<String>? secure = Future.value('');

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      _sendUnstreamed('HEAD', url, headers);

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) =>
      _sendUnstreamed('GET', url, headers);

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      _sendUnstreamed('POST', url, headers, body, encoding);

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      _sendUnstreamed('PUT', url, headers, body, encoding);

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      _sendUnstreamed('PATCH', url, headers, body, encoding);

  @override
  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      _sendUnstreamed('DELETE', url, headers, body, encoding);

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    return get(url, headers: headers).then((response) {
      _checkResponseSuccess(url, response);
      return response.body;
    });
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) {
    return get(url, headers: headers).then((response) {
      _checkResponseSuccess(url, response);
      return response.bodyBytes;
    });
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) => _client.send(request);

  /// Sends a non-streaming [Request] and returns a non-streaming [Response].
  Future<Response> _sendUnstreamed(
    String method,
    url,
    Map<String, String>? headers, [
    body,
    Encoding? encoding,
  ]) async {
    // iOS bug: Alamofire is failing to return parallel requests for certificate validation
    if (Platform.isIOS && secure != null) {
      await secure;
    }

    secure = HttpCertificatePinning.check(
      serverURL: url.toString(),
      headerHttp: {},
      sha: SHA.SHA256,
      allowedSHAFingerprints: allowedSHAFingerprints,
      timeout: 50,
    );

    secure?.whenComplete(() => secure = null);
    final secureString = await secure ?? '';

    if (secureString.contains('CONNECTION_SECURE')) {
      final request = Request(method, _fromUriOrString(url));

      if (headers != null) request.headers.addAll(headers);
      if (encoding != null) request.encoding = encoding;
      if (body != null) {
        if (body is String) {
          request.body = body;
        } else if (body is List) {
          request.bodyBytes = body.cast<int>();
        } else if (body is Map) {
          request.bodyFields = body.cast<String, String>();
        } else {
          throw ArgumentError('Invalid request body "$body".');
        }
      }

      return Response.fromStream(await send(request));
    } else {
      throw const CertificateNotVerifiedException();
    }
  }

  /// Throws an error if [response] is not successful.
  void _checkResponseSuccess(url, Response response) {
    if (response.statusCode < 400) return;
    var message = 'Request to $url failed with status ${response.statusCode}';
    if (response.reasonPhrase != null) {
      message = '$message: ${response.reasonPhrase}';
    }
    throw ClientException('$message.', _fromUriOrString(url));
  }

  @override
  void close() {
    _client.close();
  }
}

Uri _fromUriOrString(uri) => uri is String ? Uri.parse(uri) : uri as Uri;
