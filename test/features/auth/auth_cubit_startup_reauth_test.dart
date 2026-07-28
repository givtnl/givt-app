import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/network/network_info.dart';
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

  group('AuthCubit.checkAuth startup reauthentication', () {
    late _FakeAuthRepository repository;
    late AuthCubit cubit;

    final loggedInSession = Session(
      email: 'user@givt.app',
      userGUID: 'guid-1',
      accessToken: 'access',
      refreshToken: 'refresh',
      expires: DateTime.now().toUtc().add(const Duration(hours: 1)).toIso8601String(),
      expiresIn: 3600,
      isLoggedIn: true,
    );

    final refreshedSession = Session(
      email: 'user@givt.app',
      userGUID: 'guid-1',
      accessToken: 'new-access',
      refreshToken: 'new-refresh',
      expires: DateTime.now().toUtc().add(const Duration(hours: 2)).toIso8601String(),
      expiresIn: 7200,
      isLoggedIn: true,
    );

    const user = UserExt(
      email: 'user@givt.app',
      guid: 'guid-1',
      amountLimit: 499,
    );

    setUp(() {
      repository = _FakeAuthRepository(
        authenticated: (user, loggedInSession, const UserPresets.empty()),
      );
    });

    tearDown(() async {
      await cubit.close();
      repository.dispose();
    });

    test('online startup refresh success clears needsReauthentication', () async {
      repository.refreshResult = refreshedSession;
      cubit = AuthCubit(
        repository,
        networkInfo: _FakeNetworkInfo(isConnected: true),
      );

      await cubit.checkAuth(isAppStartupCheck: true);

      expect(cubit.state.status, AuthStatus.authenticated);
      expect(cubit.state.needsReauthentication, isFalse);
      expect(cubit.state.session.accessToken, 'new-access');
      expect(repository.refreshCallCount, 1);
    });

    test('online startup refresh failure sets needsReauthentication', () async {
      repository.refreshError = Exception('invalid_grant');
      cubit = AuthCubit(
        repository,
        networkInfo: _FakeNetworkInfo(isConnected: true),
      );

      await cubit.checkAuth(isAppStartupCheck: true);

      expect(cubit.state.status, AuthStatus.authenticated);
      expect(cubit.state.needsReauthentication, isTrue);
      expect(cubit.state.session.accessToken, 'access');
      expect(repository.refreshCallCount, 1);
    });

    test('offline startup skips refresh and does not require reauth', () async {
      repository.refreshError = Exception('should not be called');
      cubit = AuthCubit(
        repository,
        networkInfo: _FakeNetworkInfo(isConnected: false),
      );

      await cubit.checkAuth(isAppStartupCheck: true);

      expect(cubit.state.status, AuthStatus.authenticated);
      expect(cubit.state.needsReauthentication, isFalse);
      expect(repository.refreshCallCount, 0);
    });

    test('online startup SocketException keeps session without reauth', () async {
      repository.refreshError = const SocketException('offline');
      cubit = AuthCubit(
        repository,
        networkInfo: _FakeNetworkInfo(isConnected: true),
      );

      await cubit.checkAuth(isAppStartupCheck: true);

      expect(cubit.state.status, AuthStatus.authenticated);
      expect(cubit.state.needsReauthentication, isFalse);
      expect(repository.refreshCallCount, 1);
    });

    test('non-startup checkAuth does not refresh', () async {
      cubit = AuthCubit(
        repository,
        networkInfo: _FakeNetworkInfo(isConnected: true),
      );

      await cubit.checkAuth();

      expect(cubit.state.status, AuthStatus.authenticated);
      expect(cubit.state.needsReauthentication, isFalse);
      expect(repository.refreshCallCount, 0);
    });
  });
}

class _FakeNetworkInfo implements NetworkInfo {
  _FakeNetworkInfo({required this.isConnected});

  @override
  bool isConnected;

  @override
  Stream<bool> hasInternetConnectionStream() => const Stream.empty();
}

class _FakeAuthRepository with AuthRepository {
  _FakeAuthRepository({this.authenticated});

  final (UserExt, Session, UserPresets)? authenticated;
  final _sessionController = StreamController<bool>.broadcast();

  Object? refreshError;
  Session? refreshResult;
  int refreshCallCount = 0;

  void dispose() {
    _sessionController.close();
  }

  @override
  Future<Session> refreshToken({bool refreshUserExt = false}) async {
    refreshCallCount++;
    if (refreshError != null) {
      throw refreshError!;
    }
    return refreshResult ?? const Session.empty();
  }

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
  Future<bool> logout() async => true;

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
  }) async =>
      '';

  @override
  Future<StripeResponse> fetchStripeSetupIntent() async =>
      const StripeResponse.empty();

  @override
  Future<UserExt> registerUser({
    required TempUser tempUser,
    required bool isNewUser,
  }) async =>
      const UserExt(email: '', guid: '', amountLimit: 0);

  @override
  Future<bool> changeGiftAid({
    required String guid,
    required bool giftAid,
  }) async =>
      true;

  @override
  Future<bool> unregisterUser({required String email}) async => true;

  @override
  Future<bool> updateUser({
    required String guid,
    required Map<String, dynamic> newUserExt,
  }) async =>
      true;

  @override
  Future<bool> updateUserExt(Map<String, dynamic> newUserExt) async => true;

  @override
  Future<bool> updateLocalUserPresets({
    required UserPresets newUserPresets,
  }) async =>
      true;

  @override
  Future<void> checkUserExt({required String email}) async {}

  @override
  Future<bool> updateNotificationId({
    required String guid,
    required String notificationId,
    required bool notificationPermissionStatus,
  }) async =>
      true;

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
