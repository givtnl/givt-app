import 'dart:async';
import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/amount_presets/models/user_presets.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/utils/analytics_helper.dart';
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

  Future<bool> updateNotificationId({
    required String guid,
    required String notificationId,
  });

  Stream<UserExt?> authenticatedUserStream();

  Session getStoredSession();

  UserExt? getCurrentUser();

  void initAuth();

  Future<void> registerUser({
    required TempUser tempUser,
    required bool isNewUser,
  });
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
          'Cannot refresh token, no current session found to refresh.');
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
  }) async =>
      _apiService.updateUser(guid, newUserExt);

  @override
  Future<bool> updateUserExt(
    Map<String, dynamic> newUserExt,
  ) async =>
      _apiService.updateUserExt(newUserExt);

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
  void initAuth() {
    refreshToken();
  }
}
