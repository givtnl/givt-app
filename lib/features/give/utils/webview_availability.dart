import 'dart:io';

import 'package:flutter/services.dart';

/// Checks whether Android has a usable system WebView before opening InAppBrowser.
class WebViewAvailability {
  static const _channel = MethodChannel('net.givtapp/webview');

  static Future<bool> hasUsableWebView() async {
    if (!Platform.isAndroid) {
      return true;
    }
    try {
      final result = await _channel.invokeMethod<bool>('hasUsableWebView');
      return result ?? false;
    } on MissingPluginException {
      return true;
    }
  }
}
