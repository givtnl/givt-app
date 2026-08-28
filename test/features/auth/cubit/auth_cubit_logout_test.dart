import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/amount_presets/models/models.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/shared/models/stripe_response.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('AuthCubit.logout', () {
    late _LogoutTestAuthRepository repository;
    late AuthCubit cubit;

    const user = UserExt(
      email: 'user@givt.app',
      guid: 'guid-1',
      amountLimit: 499,
    );

    Session loggedInSession() => Session(
      email: user.email,
      userGUID: user.guid,
      accessToken: 'access',
      refreshToken: 'refresh',
      expires: DateTime.now()
          .toUtc()
          .add(const Duration(hours: 1))
          .toIso8601String(),
      expiresIn: 3600,
      isLoggedIn: true,
    );

    setUp(() {
      repository = _LogoutTestAuthRepository(
        authenticated: (user, loggedInSession(), const UserPresets.empty()),
      );
      cubit = AuthCubit(repository);
      cubit.emit(
        cubit.state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          session: loggedInSession(),
        ),
      );
    });

    tearDown(() async {
      await cubit.close();
      repository.dispose();
    });

    test('logs out on the first attempt without returning to home', () async {
      await cubit.logout();

      expect(cubit.state.status, AuthStatus.unauthenticated);
      expect(cubit.state.needsReauthentication, isFalse);
      expect(repository.logoutCallCount, 1);
    });

    test(
      'session stream false does not re-authenticate a cached session',
      () async {
        repository.emitHasSession(false);
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.status, AuthStatus.unauthenticated);
        expect(cubit.state.needsReauthentication, isFalse);
      },
    );
  });
}

class _LogoutTestAuthRepository with AuthRepository {
  _LogoutTestAuthRepository({this.authenticated});

  (UserExt, Session, UserPresets)? authenticated;
  final _sessionController = StreamController<bool>.broadcast();
  int logoutCallCount = 0;

  void dispose() {
    _sessionController.close();
  }

  void emitHasSession(bool hasSession) {
    _sessionController.add(hasSession);
  }

  @override
  Future<Session> refreshToken({bool refreshUserExt = false}) async =>
      const Session.empty();

  @override
  Future<Session> login(String email, String password) async =>
      const Session.empty();

  @override
  Future<UserExt> fetchUserExtension(String guid) async =>
      const UserExt(email: '', guid: '', amountLimit: 0);

  @override
  Future<(UserExt, Session, UserPresets)?> isAuthenticated() async =>
      authenticated;

  @override
  Future<bool> logout() async {
    logoutCallCount++;
    final current = authenticated;
    if (current != null) {
      authenticated = (
        current.$1,
        current.$2.copyWith(isLoggedIn: false),
        current.$3,
      );
    }
    _sessionController.add(false);
    return true;
  }

  @override
  Future<bool> checkTld(String email) async => true;

  @override
  Future<String> checkEmail(String email) async => '';

  @override
  Future<bool> resetPassword(String email) async => true;

  @override
  Future<String> signSepaMandate({
    required String guid,
    required String appLanguage,
  }) async => '';

  @override
  Future<StripeResponse> fetchStripeSetupIntent() async =>
      const StripeResponse.empty();

  @override
  Future<UserExt> registerUser({
    required TempUser tempUser,
    required bool isNewUser,
  }) async => const UserExt(email: '', guid: '', amountLimit: 0);

  @override
  Future<bool> changeGiftAid({
    required String guid,
    required bool giftAid,
  }) async => true;

  @override
  Future<bool> unregisterUser({required String email}) async => true;

  @override
  Future<bool> updateUser({
    required String guid,
    required Map<String, dynamic> newUserExt,
  }) async => true;

  @override
  Future<bool> updateUserExt(Map<String, dynamic> newUserExt) async => true;

  @override
  Future<bool> updateLocalUserPresets({
    required UserPresets newUserPresets,
  }) async => true;

  @override
  Future<void> checkUserExt({required String email}) async {}

  @override
  Future<bool> updateNotificationId({
    required String guid,
    required String notificationId,
    required bool notificationPermissionStatus,
  }) async => true;

  @override
  void updateSessionStream(bool hasSession) {
    if (!_sessionController.isClosed) {
      _sessionController.add(hasSession);
    }
  }

  @override
  Stream<bool> hasSessionStream() => _sessionController.stream;

  @override
  void setHasSessionInitialValue(bool hasSession) {}

  @override
  Future<Session> getStoredSession() async => const Session.empty();
}
