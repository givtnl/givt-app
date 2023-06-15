import 'dart:convert';

import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/auth/models/temp_user.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:shared_preferences/shared_preferences.dart';


mixin AuthRepositoy {
  Future<void> refreshToken();
  Future<String> login(String email, String password);
  Future<UserExt> fetchUserExtension(String guid);
  Future<UserExt?> isAuthenticated();
  Future<bool> logout();
  Future<bool> checkTld(String email);
  Future<String> checkEmail(String email);
  Future<UserExt> registerTempUser(String email, String locale);

}
class AuthRepositoyImpl with AuthRepositoy {
  AuthRepositoyImpl(
    this._prefs,
    this._apiService,
  );
  final SharedPreferences _prefs;
  final APIService _apiService;

  @override
  Future<void> refreshToken() async {
    final currentSession = _prefs.getString(Session.tag);
    if (currentSession == null) {
      return;
    }
    final session = Session.fromJson(
      jsonDecode(currentSession) as Map<String, dynamic>,
    );
    final response = await _apiService.refreshToken(
      {
        'refresh_token': session.refreshToken,
      },
    );
    final newSession = Session.fromJson(response);
    await _prefs.setString(
      Session.tag,
      jsonEncode(newSession.toJson()),
    );
  }

  @override
  Future<String> login(String email, String password) async {
    final newSession = await _apiService.login(
      {
        'username': email,
        'password': password,
        'grant_type': 'password',
      },
    );

    final session = Session.fromJson(newSession);

    await _prefs.setString(
      Session.tag,
      jsonEncode(session.toJson()),
    );

    return session.userGUID;
  }

  @override
  Future<UserExt> fetchUserExtension(String guid) async {
    final response = await _apiService.getUserExtension(guid);
    final userExt = UserExt.fromJson(response);
    await _prefs.setString(
      UserExt.tag,
      jsonEncode(userExt.toJson()),
    );
    return userExt;
  }

  @override
  Future<UserExt?> isAuthenticated() async {
    final sessionString = _prefs.getString(Session.tag);
    if (sessionString == null) {
      return null;
    }
    final session = Session.fromJson(
      jsonDecode(sessionString) as Map<String, dynamic>,
    );
    if (session.accessToken.isEmpty) {
      return null;
    }
    // if (DateTime.parse(session.expires).isBefore(DateTime.now())) {
    //   return false;
    // }

    return UserExt.fromJson(
      jsonDecode(_prefs.getString(UserExt.tag)!) as Map<String, dynamic>,
    );
  }

  @override
  Future<bool> logout() async => _prefs.remove(Session.tag);

  @override
  Future<bool> checkTld(String email) async => _apiService.checktld(email);

  @override
  Future<String> checkEmail(String email) async =>
      _apiService.checkEmail(email);

  @override
  Future<UserExt> registerTempUser(String email, String locale) async {
    final countryIso = await FlutterSimCountryCode.simCountryCode;

    final tempUser = TempUser.prefilled(
      email: email,
      country: countryIso ?? 'NL',
      appLanguage: locale,
      timeZoneId: await FlutterNativeTimezone.getLocalTimezone(),
      amountLimit: countryIso?.toUpperCase() == 'US' ? 4999 : 499,
    );

    /// register user
    final userGUID = await _apiService.registerTempUser(tempUser.toJson());

    /// create session
    await login(
      email,
      tempUser.password,
    );

    final userExt = UserExt(
      email: email,
      guid: userGUID,
      amountLimit: tempUser.amountLimit,
      tempUser: true,
    );

    await _prefs.setString(
      UserExt.tag,
      jsonEncode(userExt.toJson()),
    );

    return userExt;
  }
}
