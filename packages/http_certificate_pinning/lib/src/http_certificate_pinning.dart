import 'dart:async';

import 'package:flutter/services.dart';

enum SHA { SHA1, SHA256 }

class HttpCertificatePinning {
  static const MethodChannel _channel =
      const MethodChannel('http_certificate_pinning');

  static final HttpCertificatePinning _sslPinning =
      HttpCertificatePinning._internal();

  factory HttpCertificatePinning() => _sslPinning;

  HttpCertificatePinning._internal() {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  static Future<String> check({
    required String serverURL,
    required SHA sha,
    required List<String> allowedSHAFingerprints,
    Map<String, String>? headerHttp,
    int? timeout,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "url": serverURL,
      "headers": headerHttp ?? {},
      "type": sha.toString().split(".").last,
      "fingerprints":
          allowedSHAFingerprints.map((a) => a.replaceAll(":", "")).toList(),
      "timeout": timeout
    };
    String resp = await _channel.invokeMethod('check', params);
    return resp;
  }

  Future _platformCallHandler(MethodCall call) async {
    print("_platformCallHandler call ${call.method} ${call.arguments}");
  }
}
