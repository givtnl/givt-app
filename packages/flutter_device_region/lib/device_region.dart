import 'dart:async';

import 'package:flutter/services.dart';

class DeviceRegion {
  static const MethodChannel _channel = MethodChannel('device_region');

  /// ## Android:
  /// 
  /// Using [TelephonyManager][1] class:
  /// 
  /// Returns *simCountryIso* if available. Otherwise, it should return *networkCountryIso*. 
  ///
  /// In case the value cannot be retrieved or an error occurs, null value will be returned
  /// 
  /// [1]: https://developer.android.com/reference/android/telephony/TelephonyManager
  /// 
  /// ## iOS:
  /// 
  /// Using [CTTelephonyNetworkInfo][2] class:
  /// 
  /// Returns [*isoCountryCode*][3] if available.
  ///
  /// In case the value cannot be retrieved or an error occurs, null value will be returned
  /// 
  /// [2]: https://developer.apple.com/documentation/coretelephony/cttelephonynetworkinfo
  /// [3]: https://developer.apple.com/documentation/coretelephony/ctcarrier/1620317-isocountrycode
  /// 

  static Future<String?> getSIMCountryCode() async =>
      await _channel.invokeMethod(
        'getSIMCountryCode',
      );
}
