import 'dart:async';
import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/amount_presets/models/models.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/children/generosity_challenge/domain/models/generosity_registration_result.dart';
import 'package:givt_app/shared/models/stripe_response.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin AuthRepository {
  Future<Session> refreshToken({bool refreshUserExt = false});

  Future<Session> login(String email, String password);

  Future<UserExt> fetchUserExtension(String guid);

  Future<(UserExt, Session, UserPresets)?> isAuthenticated();

  Future<bool> logout();

  Future<bool> checkTld(String email);

  Future<String> checkEmail(String email);

  Future<bool> resetPassword(String email);

  Future<String> signSepaMandate({
    required String guid,
    required String appLanguage,
  });

  Future<StripeResponse> fetchStripeSetupIntent();

  Future<UserExt> registerUser({
    required TempUser tempUser,
    required bool isNewUser,
  });

  Future<GenerosityRegistrationResult> registerGenerosityChallengeUser({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    String? phoneNumber,
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

  Future<bool> updateLocalUserPresets({
    required UserPresets newUserPresets,
  });

  Future<void> checkUserExt({
    required String email,
  });

  Future<bool> updateNotificationId({
    required String guid,
    required String notificationId,
  });

  void updateSessionStream(bool hasSession);

  Stream<bool> hasSessionStream();

  void setHasSessionInitialValue(bool hasSession);
}

class AuthRepositoyImpl with AuthRepository {
  AuthRepositoyImpl(
    this._prefs,
    this._apiService,
  );

  final SharedPreferences _prefs;
  final APIService _apiService;
  bool? _hasSession;

  // bool hasSession
  final StreamController<bool> _hasSessionStreamController =
      StreamController<bool>.broadcast();

  @override
  Stream<bool> hasSessionStream() => _hasSessionStreamController.stream;

  @override
  Future<Session> refreshToken({bool refreshUserExt = false}) async {
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
    if (refreshUserExt) {
      try {
        await fetchUserExtension(newSession.userGUID);
        updateSessionStream(true);
      } catch (e, s) {
        LoggingInfo.instance.error(
          e.toString(),
          methodName: s.toString(),
        );
      }
    }
    await _fetchUserExtension();
    return newSession;
  }

  Future<void> _fetchUserExtension() async {
    try {
      if (!_prefs.containsKey(UserExt.tag)) {
        return;
      }
      final userExt = UserExt.fromJson(
        jsonDecode(
          _prefs.getString(UserExt.tag)!,
        ) as Map<String, dynamic>,
      );
      final response = await _apiService.getUserExtension(userExt.guid);
      final newUserExt = UserExt.fromJson(response);
      await _prefs.setString(
        UserExt.tag,
        jsonEncode(newUserExt.toJson()),
      );

      await setUserProperties(newUserExt);
    } catch (e, stacktrace) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stacktrace.toString(),
      );
    }
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
  Future<void> checkUserExt({
    required String email,
  }) async {
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

    await setUserProperties(userExt);
    return userExt;
  }

  @override
  Future<(UserExt, Session, UserPresets)?> isAuthenticated() async {
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

    final userExtString = _prefs.getString(UserExt.tag);
    if (userExtString == null) {
      return null;
    }

    if (userExtString.isEmpty) {
      return null;
    }

    final decodedJson = jsonDecode(userExtString);
    if (decodedJson is! Map<String, dynamic>) {
      return null;
    }

    final userExt = UserExt.fromJson(decodedJson);

    if (userExt.guid.isEmpty) {
      return null;
    }
    if (userExt.email.isEmpty) {
      return null;
    }
    if (userExt.country.isEmpty) {
      return null;
    }
    if (userExt.needRegistration && !userExt.tempUser) {
      return null;
    }

    if (!_prefs.containsKey(AmountPresets.tag)) {
      return (userExt, session, const UserPresets.empty());
    }

    /// if the amount presets are not present in the cache set it to empty
    if (!_prefs.containsKey(AmountPresets.tag)) {
      await _prefs.setString(
        AmountPresets.tag,
        jsonEncode(
          const AmountPresets.empty().toJson(),
        ),
      );
    }

    final amountPresetsString = _prefs.getString(AmountPresets.tag);

    final amountPresets = AmountPresets.fromJson(
      jsonDecode(
        amountPresetsString!,
      ) as Map<String, dynamic>,
    );

    if (amountPresets.presets.isEmpty) {
      return (userExt, session, const UserPresets.empty());
    }
    final userPreset = amountPresets.presets.firstWhere(
      (element) => element.guid == userExt.guid,
      orElse: () => const UserPresets.empty(),
    );

    if (userPreset.guid.isEmpty) {
      return (userExt, session, userPreset.copyWith(guid: userExt.guid));
    }

    // if (DateTime.parse(session.expires).isBefore(DateTime.now())) {
    //   return false;
    // }

    return (userExt, session, userPreset);
  }

  @override
  Future<bool> logout() async {
    // _prefs.clear();
    final sessionString = _prefs.getString(Session.tag);

    updateSessionStream(false);

    // If the data is already gone, just continue :)
    if (sessionString == null) {
      return true;
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
    required bool isNewUser,
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
      tempUser: isNewUser,
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
  }) async {
    final isSuccess = await _apiService.unregisterUser({
      'email': email,
    });
    if (isSuccess) {
      await _prefs.clear();
    }
    return isSuccess;
  }

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
  Future<StripeResponse> fetchStripeSetupIntent() async {
    final reponse = await _apiService.fetchStripeSetupIntent();
    final stripeResponse = StripeResponse.fromJson(reponse);
    return stripeResponse;
  }

  @override
  Future<bool> updateLocalUserPresets({
    required UserPresets newUserPresets,
  }) async {
    if (!_prefs.containsKey(AmountPresets.tag)) {
      await _prefs.setString(
        AmountPresets.tag,
        jsonEncode(
          AmountPresets(
            presets: [newUserPresets],
          ).toJson(),
        ),
      );
    }

    final amountPresets = AmountPresets.fromJson(
      jsonDecode(
        _prefs.getString(AmountPresets.tag)!,
      ) as Map<String, dynamic>,
    );

    for (final userPreset in amountPresets.presets) {
      if (userPreset.guid == newUserPresets.guid) {
        amountPresets.updateUserPresets(
          userPreset.copyWith(
            presets: newUserPresets.presets,
          ),
        );
      }
    }

    final isSuccess = _prefs.setString(
      AmountPresets.tag,
      jsonEncode(amountPresets.toJson()),
    );

    return isSuccess;
  }

  @override
  Future<bool> updateNotificationId({
    required String guid,
    required String notificationId,
  }) =>
      _apiService.updateNotificationId(
        guid: guid,
        body: {
          'PushNotificationId': notificationId,
          'OS': 1, // Always use firebase implementation from Android
        },
      );

  Future<void> setUserProperties(UserExt newUserExt) {
    FirebaseCrashlytics.instance.setUserIdentifier(newUserExt.guid);

    return AnalyticsHelper.setUserProperties(
      userId: newUserExt.guid,
      userProperties: AnalyticsHelper.getUserPropertiesFromExt(newUserExt),
    );
  }

  @override
  Future<GenerosityRegistrationResult> registerGenerosityChallengeUser({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    Map<String, dynamic>? response;
    try {
      final userStatus = await _apiService.checkEmail(email);
      if (userStatus.contains('temp')) {
        final tempUser = TempUser(
          email: email,
          country: Country.us.countryCode,
          appLanguage: 'en',
          timeZoneId: await FlutterTimezone.getLocalTimezone(),
          address: Util.defaultAdress,
          city: Util.defaultCity,
          postalCode: Util.defaultPostCode,
          phoneNumber: phoneNumber ?? Util.defaultUSPhoneNumber,
          iban: Util.defaultIban,
          sortCode: Util.empty,
          accountNumber: Util.empty,
          amountLimit: 4999,
          firstName: firstname,
          lastName: lastname,
          password: password,
        );
        // updates the user extension with the temp user
        // and updates the session
        await registerUser(tempUser: tempUser, isNewUser: false);
        return GenerosityRegistrationResult.success();
      }
      if (userStatus.contains('true')) {
        return GenerosityRegistrationResult.alreadyRegistered();
      }
    } catch (e) {
      return GenerosityRegistrationResult.failure();
    }
    try {
      response = await _apiService.registerGenerosityChallengeUser(
        {
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'password': password,
        },
      );
    } catch (e) {
      return GenerosityRegistrationResult.failure();
    }

    try {
      final newSession =
          Session.fromGenerosityJson(response['item'] as Map<String, dynamic>);
      await _prefs.setString(
        Session.tag,
        jsonEncode(
          newSession.toJson(),
        ),
      );
      await fetchUserExtension(newSession.userGUID);
    } catch (e) {
      //failing one of these is non-blocking
    } finally {
      updateSessionStream(true);
    }
    if (response['errorMessage'] == 'USER_ALREADY_EXISTS') {
      return GenerosityRegistrationResult.alreadyRegistered();
    } else {
      return GenerosityRegistrationResult.success();
    }
  }

  @override
  void updateSessionStream(bool hasSession) {
    if (_hasSession != hasSession) {
      _hasSession = hasSession;
      _hasSessionStreamController.add(hasSession);
    }
  }

  @override
  void setHasSessionInitialValue(bool hasSession) {
    _hasSession = hasSession;
  }
}
