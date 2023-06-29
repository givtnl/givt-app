import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:sim_data_plus/sim_data.dart';

mixin CountryIsoInfo {
  Future<String> get checkCountryIso;

  String get countryIso;

  bool get isUS;
}

class CountryIsoInfoImpl implements CountryIsoInfo {
  CountryIsoInfoImpl();

  String _countryIso = Country.us.countryCode;

  @override
  Future<String> get checkCountryIso async {
    try {
      _countryIso =
          await FlutterSimCountryCode.simCountryCode ?? Country.us.countryCode;
    } on PlatformException catch (e) {
      log(e.toString());
    }
    return _countryIso;
  }

  @override
  String get countryIso => _countryIso;

  @override
  bool get isUS => _countryIso == Country.us.countryCode;
}
