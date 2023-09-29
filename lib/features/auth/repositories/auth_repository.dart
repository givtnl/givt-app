import 'dart:convert';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/shared/models/stripe_response.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/shared/models/user_ext.dart';
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

    // if (DateTime.parse(session.expires).isBefore(DateTime.now())) {
    //   return false;
    // }

    return (userExt, session);
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
}
