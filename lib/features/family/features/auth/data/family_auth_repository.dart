import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/amount_presets/models/user_presets.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FamilyAuthRepository {
  Future<Session> refreshToken();

  Future<void> login(String email, String password);

  Future<(UserExt, Session, UserPresets)?> isAuthenticated();

  Future<bool> logout();

  Future<bool> updateUser({
    required String guid,
    required Map<String, dynamic> newUserExt,
  });

  Future<bool> updateUserExt(Map<String, dynamic> newUserExt);

  Future<void> checkUserExt({
    required String email,
  });

  Future<String> checkEmail({
    required String email,
  });

  Future<void> updateNotificationId();

  Stream<UserExt?> authenticatedUserStream();

  Stream<void> registrationFinishedStream();

  Session getStoredSession();

  UserExt? getCurrentUser();

  Future<void> initAuth();

  Future<void> registerUser({
    required TempUser tempUser,
    required bool isNewUser,
  });

  Future<void> refreshUser() async {}

  void onRegistrationFinished();

  void onRegistrationStarted();

  void onRegistrationCancelled();

  bool hasUserStartedRegistration();

  Future<void> updateNumber(String number);
}

class FamilyAuthRepositoryImpl implements FamilyAuthRepository {
  FamilyAuthRepositoryImpl(
    this._prefs,
    this._apiService,
  );

  final SharedPreferences _prefs;
  final APIService _apiService;
  UserExt? _userExt;

  // bool hasSession
  final StreamController<UserExt?> _authenticatedUserStream =
      StreamController<UserExt?>.broadcast();

  final StreamController<void> _onRegistrationFinishedStream =
      StreamController<void>.broadcast();

  bool _startedRegistration = false;

  //emits a userExt object when we have an authenticated user, else null
  @override
  Stream<UserExt?> authenticatedUserStream() =>
      _authenticatedUserStream.stream.distinct();

  @override
  Future<Session> refreshToken() async {
    final session = getStoredSession();
    if (session == const Session.empty()) {
      _authenticatedUserStream.add(null);
      throw Exception(
        'Cannot refresh token, no current session found to refresh.',
      );
    }
    if (session.isLoggedIn == false) {
      _authenticatedUserStream.add(null);
      throw Exception('Cannot refresh token, user is not logged in.');
    }
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
    await _storeSession(newSession);
    try {
      await _fetchUserExtension(newSession.userGUID);
    } catch (e, s) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
    }
    return newSession;
  }

  @override
  Future<void> login(String email, String password) async {
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

    await _storeSession(session);
    await _fetchUserExtension(session.userGUID);
  }

  Future<bool> _storeSession(Session session) async {
    return _prefs.setString(
      Session.tag,
      jsonEncode(
        session.toJson(),
      ),
    );
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
  Future<String> checkEmail({required String email}) async =>
      _apiService.checkEmail(email);

  Future<UserExt> _fetchUserExtension(String guid) async {
    try {
      final response = await _apiService.getUserExtension(guid);
      final userExt = UserExt.fromJson(response);
      await _storeUserExt(userExt);
      await _setUserPropsForExternalServices(userExt);
      _updateAuthenticatedUserStream(userExt);
      return userExt;
    } catch (e, s) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
      rethrow;
    }
  }

  Future<void> _storeUserExt(UserExt userExt) async {
    await _prefs.setString(
      UserExt.tag,
      jsonEncode(userExt.toJson()),
    );
    _updateAuthenticatedUserStream(userExt);
  }

  @override
  Session getStoredSession() {
    final sessionString = _prefs.getString(Session.tag);
    if (sessionString == null) {
      return const Session.empty();
    }
    try {
      final session = Session.fromJson(
        jsonDecode(sessionString) as Map<String, dynamic>,
      );
      return session;
    } catch (e, s) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
      return const Session.empty();
    }
  }

  @override
  Future<(UserExt, Session, UserPresets)?> isAuthenticated() async {
    final session = getStoredSession();
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

    return (userExt, session, const UserPresets.empty());
  }

  @override
  Future<bool> logout() async {
    _startedRegistration = false;

    // _prefs.clear();
    final sessionString = _prefs.getString(Session.tag);

    _updateAuthenticatedUserStream(null);

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
  Future<void> registerUser({
    required TempUser tempUser,
    required bool isNewUser,
  }) async {
    /// register user
    final userGUID = await _apiService.registerUser(tempUser.toJson());
    await AnalyticsHelper.setUserProperties(userId: userGUID);

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

    await _storeUserExt(userExt);
  }

  @override
  Future<bool> updateUser({
    required String guid,
    required Map<String, dynamic> newUserExt,
  }) async {
    try {
      final result = await _apiService.updateUser(guid, newUserExt);
      await _fetchUserExtension(guid);
      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateUserExt(
    Map<String, dynamic> newUserExt,
  ) async {
    try {
      final result = _apiService.updateUserExt(newUserExt);
      await refreshUser();
      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateNotificationId() async {
    LoggingInfo.instance.info('Update Notification Id');

    if (Platform.isIOS) {
      // On iOS be sure that APNS token is available before asking for a firebase token
      await FirebaseMessaging.instance.getAPNSToken();
    }

    final notificationId = await FirebaseMessaging.instance.getToken();

    LoggingInfo.instance.info('New FCM token: $notificationId');
    final notificationPermissionStatus =
        await Permission.notification.status.isGranted;

    if (notificationId == null) {
      LoggingInfo.instance.warning(
        'FCM token: is null',
      );
      return;
    }
    if (_userExt!.notificationId == notificationId &&
        _userExt!.pushNotificationsEnabled == notificationPermissionStatus) {
      LoggingInfo.instance.info(
        'FCM token: $notificationId is the same as the current one',
      );

      return;
    }

    await _apiService.updateNotificationId(
      guid: _userExt!.guid,
      body: {
        'PushNotificationId': notificationId,
        'PushNotificationsEnabled': notificationPermissionStatus,
      },
    );
    await _fetchUserExtension(_userExt!.guid);
  }

  Future<void> _setUserPropsForExternalServices(UserExt newUserExt) {
    FirebaseCrashlytics.instance.setUserIdentifier(newUserExt.guid);

    return AnalyticsHelper.setUserProperties(
      userId: newUserExt.guid,
      userProperties: AnalyticsHelper.getUserPropertiesFromExt(newUserExt),
    );
  }

  void _updateAuthenticatedUserStream(UserExt? userExt) {
    _userExt = userExt;
    _authenticatedUserStream.add(userExt);
  }

  @override
  UserExt? getCurrentUser() => _userExt;

  @override
  Future<void> initAuth() async {
    try {
      await refreshToken();
      await updateNotificationId();
    } catch (e, s) {
      LoggingInfo.instance.info('Error in initAuth');
      LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
    }
  }

  @override
  Future<void> refreshUser() async {
    await _fetchUserExtension(_userExt!.guid);
  }

  @override
  void onRegistrationFinished() {
    _startedRegistration = false;
    _onRegistrationFinishedStream.add(null);
  }

  @override
  void onRegistrationStarted() => _startedRegistration = true;

  @override
  bool hasUserStartedRegistration() => _startedRegistration;

  @override
  Stream<void> registrationFinishedStream() =>
      _onRegistrationFinishedStream.stream;

  @override
  void onRegistrationCancelled() => _startedRegistration = false;

  @override
  Future<void> updateNumber(String number) async {
    final newUserExt = _userExt!.copyWith(phoneNumber: number);
    final result = _apiService.updateUserExt(newUserExt.toJson());
    _updateAuthenticatedUserStream(newUserExt);
  }
}
