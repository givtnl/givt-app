import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/shared/models/stripe_response.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:native_shared_preferences/native_shared_preferences.dart';
import 'package:propertylistserialization/propertylistserialization.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin AuthRepositoy {
  Future<Session> refreshToken();
  Future<Session> login(String email, String password);
  Future<UserExt> fetchUserExtension(String guid);
  Future<(UserExt, Session)?> isAuthenticated();
  Future<bool> logout();
  Future<bool> checkTld(String email);
  Future<String> checkEmail(String email);
  Future<bool> resetPassword(String email);
  Future<String> signSepaMandate({
    required String guid,
    required String appLanguage,
  });
  Future<StripeResponse> registerStripeCustomer({required String email});
  Future<UserExt> registerUser({
    required TempUser tempUser,
    required bool isTempUser,
  });
  Future<bool> changeGiftAid({
    required String guid,
    required bool giftAid,
  });
  Future<bool> unregisterUser({
    required String email,
  });
  Future<bool> updateUser({
    required String guid,
    required Map<String, dynamic> newUserExt,
  });

  Future<bool> updateUserExt(Map<String, dynamic> newUserExt);

  Future<bool> updateLocalUserExt({
    required UserExt newUserExt,
  });

  Future<void> checkUserExt({
    required String email,
  });
}

class AuthRepositoyImpl with AuthRepositoy {
  AuthRepositoyImpl(
    this._prefs,
    this._apiService,
  );
  final SharedPreferences _prefs;
  final APIService _apiService;

  @override
  Future<Session> refreshToken() async {
    final currentSession = _prefs.getString(Session.tag);
    if (currentSession == null) {
      return const Session.empty();
    }
    final session = Session.fromJson(
      jsonDecode(currentSession) as Map<String, dynamic>,
    );
    final response = await _apiService.refreshToken(
      {
        'refresh_token': session.refreshToken,
        'grant_type': 'refresh_token',
      },
    );
    var newSession = Session.fromJson(response);
    newSession = newSession.copyWith(
      isLoggedIn: true,
    );
    await _prefs.setString(
      Session.tag,
      jsonEncode(
        newSession.toJson(),
      ),
    );
    return newSession;
  }

  @override
  Future<Session> login(String email, String password) async {
    final newSession = await _apiService.login(
      {
        'username': email,
        'password': password,
        'grant_type': 'password',
      },
    );

    var session = Session.fromJson(newSession);
    session = session.copyWith(
      isLoggedIn: true,
    );
    await _prefs.setString(
      Session.tag,
      jsonEncode(
        session.toJson(),
      ),
    );

    return session;
  }

  @override
  Future<void> checkUserExt({required String email}) async {
    if (!_prefs.containsKey(UserExt.tag)) {
      return;
    }
    final userExt = UserExt.fromJson(
      jsonDecode(
        _prefs.getString(UserExt.tag)!,
      ) as Map<String, dynamic>,
    );
    if (userExt.email == email) {
      return;
    }
    await _prefs.clear();
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
  Future<(UserExt, Session)?> isAuthenticated() async {
    try {
      await _copyFromNative();
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      await LoggingInfo.instance.error(
        'Error migrating native keys, setting migration to true',
      );
      await _prefs.setBool(
        Util.nativeAppKeysMigration,
        true,
      );
    }

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

    return (
      UserExt.fromJson(
        jsonDecode(_prefs.getString(UserExt.tag)!) as Map<String, dynamic>,
      ),
      session
    );
  }

  @override
  Future<bool> logout() async {
    // _prefs.clear();
    final sessionString = _prefs.getString(Session.tag);
    if (sessionString == null) {
      throw Exception('No session found');
    }
    final session = Session.fromJson(
      jsonDecode(sessionString) as Map<String, dynamic>,
    );
    return _prefs.setString(
      Session.tag,
      jsonEncode(
        session
            .copyWith(
              isLoggedIn: false,
            )
            .toJson(),
      ),
    );
  }

  @override
  Future<bool> checkTld(String email) async => _apiService.checktld(email);

  @override
  Future<String> signSepaMandate({
    required String guid,
    required String appLanguage,
  }) async {
    final response = await _apiService.signSepaMandate(
      guid,
      appLanguage,
    );
    return response;
  }

  @override
  Future<String> checkEmail(String email) async =>
      _apiService.checkEmail(email);

  @override
  Future<UserExt> registerUser({
    required TempUser tempUser,
    required bool isTempUser,
  }) async {
    /// register user
    final userGUID = await _apiService.registerUser(tempUser.toJson());

    /// create session
    await login(
      tempUser.email,
      tempUser.password,
    );

    final userExt = UserExt(
      email: tempUser.email,
      guid: userGUID,
      amountLimit: tempUser.amountLimit,
      tempUser: isTempUser,
      country: tempUser.country,
      phoneNumber: tempUser.phoneNumber,
      firstName: tempUser.firstName,
      lastName: tempUser.lastName,
      appLanguage: tempUser.appLanguage,
      address: tempUser.address,
      city: tempUser.city,
      postalCode: tempUser.postalCode,
      iban: tempUser.iban,
      sortCode: tempUser.sortCode,
      accountNumber: tempUser.accountNumber,
    );

    await _prefs.setString(
      UserExt.tag,
      jsonEncode(userExt.toJson()),
    );

    return userExt;
  }

  @override
  Future<bool> changeGiftAid({
    required String guid,
    required bool giftAid,
  }) async {
    return _apiService.changeGiftAid(
      guid,
      {'authorised': giftAid},
    );
  }

  @override
  Future<bool> resetPassword(String email) =>
      _apiService.resetPassword({'email': email});

  @override
  Future<bool> unregisterUser({
    required String email,
  }) async =>
      _apiService.unregisterUser({
        'email': email,
      });

  @override
  Future<bool> updateUser({
    required String guid,
    required Map<String, dynamic> newUserExt,
  }) async =>
      _apiService.updateUser(guid, newUserExt);

  @override
  Future<bool> updateUserExt(
    Map<String, dynamic> newUserExt,
  ) async =>
      _apiService.updateUserExt(newUserExt);

  @override
  Future<StripeResponse> registerStripeCustomer({required String email}) async {
    final reponse = await _apiService.registerStripeCustomer(email);
    final stripeResponse = StripeResponse.fromJson(reponse);
    return stripeResponse;
  }

  Future<bool> updateLocalUserExt({
    required UserExt newUserExt,
  }) async =>
      _prefs.setString(
        UserExt.tag,
        jsonEncode(newUserExt),
      );

  Future<void> _copyFromNative() async {
    await LoggingInfo.instance.info('Start Migration...');
    final nativePrefs = await NativeSharedPreferences.getInstance();

    if (_prefs.containsKey(Util.nativeAppKeysMigration)) {
      final isMigrated = _prefs.getBool(Util.nativeAppKeysMigration) ?? false;
      if (isMigrated) {
        return;
      }
    }

    await LoggingInfo.instance
        .info('Migrating ${nativePrefs.getKeys().toList()} native keys');

    if (nativePrefs.getKeys().isEmpty) {
      await LoggingInfo.instance.info('No native keys to migrate');
      await _prefs.setBool(
        Util.nativeAppKeysMigration,
        true,
      );
      return;
    }

    for (var i = 0; i < nativePrefs.getKeys().length; i++) {
      final key = nativePrefs.getKeys().elementAt(i);
      final value = nativePrefs.get(key);

      if (_prefs.containsKey(key)) {
        continue;
      }

      if (key.contains('flutter.')) {
        continue;
      }

      if (key == NativeNSUSerDefaultsKeys.orgBeaconListV2 ||
          key == NativeNSUSerDefaultsKeys.orgBeaconList) {
        continue;
      }

      if (value is String) {
        await _prefs.setString(key, value);
      } else if (value is int) {
        await _prefs.setInt(key, value);
      } else if (value is double) {
        await _prefs.setDouble(key, value);
      } else if (value is bool) {
        await _prefs.setBool(key, value);
      } else if (value is List<String>) {
        await _prefs.setStringList(key, value);
      } else if (value is List<int> && Platform.isIOS) {
        // UnmodifiableUint8ArrayView
        try {
          final list = Uint8List.fromList(value);
          final archive = PropertyListSerialization.propertyListWithData(
            list.buffer.asByteData(),
            keyedArchive: true,
          );
          if (archive is! Map<String, Object?>) {
            continue;
          }
          if (!archive.containsKey(r'$objects')) {
            continue;
          }
          if (archive[r'$objects'] == null) {
            continue;
          }
          final objectList = archive[r'$objects']! as List<dynamic>;
          if (key == NativeNSUSerDefaultsKeys.userExtiOS) {
            if (objectList[2] is! String ||
                objectList[3] is! String ||
                objectList[4] is! String) {
              continue;
            }
            final userExt = const UserExt.empty().copyWith(
              guid: objectList[2] as String,
              email: objectList[3] as String,
              country: objectList[4] as String,
            );
            await _prefs.setString(key, jsonEncode(userExt.toJson()));
          }
        } catch (e, stackTrace) {
          await LoggingInfo.instance.error(
            e.toString(),
            methodName: stackTrace.toString(),
          );
        }
      } else if (value is List<Object?>) {
        await _prefs.setString(
          key,
          jsonEncode(value),
        );
      } else if (value == null) {
        await _prefs.remove(key);
      } else {
        await LoggingInfo.instance
            .info('Unknown type for key $key: ${value.runtimeType}');
      }
    }

    await _restoreUser();
    if (Platform.isAndroid &&
        _prefs.containsKey(NativeSharedPreferencesKeys.cachedGivts)) {
      await _restoreOfflineGivts();
    }

    await LoggingInfo.instance.info(
      '${_prefs.getKeys().toList()} shared keys migrated on ${DateTime.now()}',
    );

    await _prefs.setBool(
      Util.nativeAppKeysMigration,
      true,
    );
  }

  Future<void> _restoreUser() async {
    final user = _prefs.getString(NativeNSUSerDefaultsKeys.userExtiOS) ??
        _prefs.getString(NativeSharedPreferencesKeys.prefsUser);

    if (user == null) {
      return;
    }

    var userExt = UserExt.fromJson(
      jsonDecode(
        user,
      ) as Map<String, dynamic>,
    );

    if (Platform.isAndroid &&
        _prefs.containsKey(NativeSharedPreferencesKeys.latestSelectedBeacon)) {
      final organisation = Organisation.fromJson(
        jsonDecode(
          _prefs.getString(
            NativeSharedPreferencesKeys.latestSelectedBeacon,
          )!,
        ) as Map<String, dynamic>,
      );
      await _prefs.setString(
        Organisation.lastOrganisationDonatedKey,
        jsonEncode(
          organisation.toJson(),
        ),
      );
    }
    if (Platform.isIOS &&
        _prefs.containsKey(NativeNSUSerDefaultsKeys.lastGivtToOrganisation)) {
      var organisation = const Organisation.empty();
      organisation = organisation.copyWith(
        organisationName: _prefs.getString(
          NativeNSUSerDefaultsKeys.lastGivtToOrganisation_name,
        ),
        mediumId: _prefs.getString(
          NativeNSUSerDefaultsKeys.lastGivtToOrganisation,
        ),
      );
      await _prefs.setString(
        Organisation.lastOrganisationDonatedKey,
        jsonEncode(
          organisation.toJson(),
        ),
      );
    }

    userExt = userExt.copyWith(
      tempUser: Platform.isIOS
          ? _prefs.getBool(NativeNSUSerDefaultsKeys.tempUser)
          : _prefs.getBool(NativeSharedPreferencesKeys.prefsTempUser),
      mandateSigned: Platform.isIOS
          ? _prefs.getBool(NativeNSUSerDefaultsKeys.mandateSigned)
          : _prefs.getBool(NativeSharedPreferencesKeys.mandateSigned),
      amountLimit: _prefs.getInt(NativeNSUSerDefaultsKeys.amountLimit),
      accountType: AccountType.fromString(
        _prefs.getString(NativeNSUSerDefaultsKeys.accountType) ?? '',
      ),
    );

    await _prefs.setString(
      UserExt.tag,
      jsonEncode(
        userExt.toJson(),
      ),
    );
    try {
      final bearer = _getSaveToken();
      final expiration = _getExpiration();

      await _prefs.setString(
        Session.tag,
        jsonEncode(
          Session(
            email: userExt.email,
            userGUID: userExt.guid,
            accessToken: bearer,
            refreshToken: bearer,
            expires: expiration,
            expiresIn: 0,
            isLoggedIn: true,
          ).toJson(),
        ),
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
    }
  }

  String _getExpiration() {
    if (Platform.isIOS) {
      return '';
    }
    final expirationString = _prefs.getString(
      NativeSharedPreferencesKeys.bearerToken,
    );

    if (expirationString == null) {
      return '';
    }
    if (expirationString.isEmpty) {
      return '';
    }
    final expiration = jsonDecode(
      expirationString,
    );
    if (expiration is! Map<String, dynamic>) {
      return '';
    }

    if (!expiration.containsKey('Expiration')) {
      return '';
    }

    return expiration['Expiration'] as String;
  }

  String _getSaveToken() {
    if (Platform.isIOS &&
        _prefs.containsKey(NativeNSUSerDefaultsKeys.bearerToken)) {
      if (_prefs.getString(NativeNSUSerDefaultsKeys.bearerToken) == null) {
        return '';
      }
      return _prefs.getString(NativeNSUSerDefaultsKeys.bearerToken)!;
    }
    if (!_prefs.containsKey(NativeSharedPreferencesKeys.bearerToken)) {
      return '';
    }

    final bearerTokenString = _prefs.getString(
      NativeSharedPreferencesKeys.bearerToken,
    );

    if (bearerTokenString == null) {
      return '';
    }

    if (bearerTokenString.isEmpty) {
      return '';
    }

    final bearerToken = jsonDecode(
      bearerTokenString,
    );

    if (bearerToken is! Map<String, dynamic>) {
      return '';
    }

    if (!bearerToken.containsKey('Token')) {
      return '';
    }

    return bearerToken['Token'] as String;
  }

  Future<void> _restoreOfflineGivts() async {
    final offlineGivtsString = _prefs.getString(
          NativeSharedPreferencesKeys.cachedGivts,
        ) ??
        '';

    if (offlineGivtsString.isEmpty) {
      return;
    }

    final decodedGivts = jsonDecode(offlineGivtsString) as List<dynamic>;

    final offlineGivts = GivtTransaction.fromJsonList(
      decodedGivts,
    );

    if (offlineGivts.isEmpty) {
      return;
    }

    await LoggingInfo.instance.info(
      'Restoring ${offlineGivts.length} offline givts: $offlineGivtsString',
    );

    await _prefs.setString(
      GivtTransaction.givtTransactions,
      jsonEncode(
        <String, dynamic>{
          'donationType': 0,
        }..addAll(
            {
              'donations': GivtTransaction.toJsonList(
                offlineGivts,
              ),
            },
          ),
      ),
    );
  }
}
