import 'dart:developer';
import 'package:device_region/device_region.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin CountryIsoInfo {
  Future<String> get checkCountryIso;

  String get countryIso;

  bool get isUS;
}

class CountryIsoInfoImpl implements CountryIsoInfo {
  CountryIsoInfoImpl();

  String _countryIso = Country.nl.countryCode;

  @override
  Future<String> get checkCountryIso async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localCountryIso = prefs.getString(Util.countryIso);

      if (localCountryIso != null) {
        _countryIso = localCountryIso;
      } else {
        _countryIso =
            (await DeviceRegion.getSIMCountryCode() ?? Country.nl.countryCode)
                .toUpperCase();
      }
    } on PlatformException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
    return _countryIso;
  }

  @override
  String get countryIso => _countryIso;

  @override
  bool get isUS => _countryIso == Country.us.countryCode;
}
