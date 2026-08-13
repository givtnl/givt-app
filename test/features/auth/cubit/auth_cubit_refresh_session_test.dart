import 'dart:async';
import 'dart:io';

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

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AuthCubit.refreshSession', () {
    late _RefreshTestAuthRepository repository;
    late AuthCubit cubit;

    setUp(() {
      repository = _RefreshTestAuthRepository();
      cubit = AuthCubit(repository);
    });

    tearDown(() async {
      await cubit.close();
      await repository.dispose();
    });

    Session refreshedSession() {
      final expires = DateTime.now().toUtc().add(const Duration(minutes: 30));
      return Session(
        email: 'user@example.com',
        userGUID: 'guid',
        accessToken: 'new-access',
        refreshToken: 'new-refresh',
        expires: expires.toIso8601String(),
        expiresIn: 1800,
        isLoggedIn: true,
      );
    }

    test('updates session when emitAuthentication is false', () async {
      repository.refreshResult = refreshedSession();
      cubit.emit(
        cubit.state.copyWith(
          status: AuthStatus.authenticated,
          session: Session(
            email: 'user@example.com',
            userGUID: 'guid',
            accessToken: 'old-access',
            refreshToken: 'old-refresh',
            expires: '2000-01-01T00:00:00.000Z',
            expiresIn: 0,
            isLoggedIn: true,
          ),
        ),
      );

      final result = await cubit.refreshSession(emitAuthentication: false);

      expect(result, RefreshSessionResult.success);
      expect(cubit.state.status, AuthStatus.authenticated);
      expect(cubit.state.session.accessToken, 'new-access');
    });

    test('does not change status on failure when emitAuthentication is false',
        () async {
      repository.refreshError = Exception('refresh failed');
      cubit.emit(
        cubit.state.copyWith(
          status: AuthStatus.authenticated,
        ),
      );

      final result = await cubit.refreshSession(emitAuthentication: false);

      expect(result, RefreshSessionResult.failure);
      expect(cubit.state.status, AuthStatus.authenticated);
    });

    test('sets failure status when emitAuthentication is true and refresh fails',
        () async {
      repository.refreshError = Exception('refresh failed');

      final result = await cubit.refreshSession();

      expect(result, RefreshSessionResult.failure);
      expect(cubit.state.status, AuthStatus.failure);
    });

    test('sets noInternet when emitAuthentication is true and offline', () async {
      repository.refreshError = const SocketException('offline');

      final result = await cubit.refreshSession();

      expect(result, RefreshSessionResult.offline);
      expect(cubit.state.status, AuthStatus.noInternet);
    });

    test('returns offline without changing status when emitAuthentication is false',
        () async {
      repository.refreshError = const SocketException('offline');
      cubit.emit(
        cubit.state.copyWith(
          status: AuthStatus.authenticated,
        ),
      );

      final result = await cubit.refreshSession(emitAuthentication: false);

      expect(result, RefreshSessionResult.offline);
      expect(cubit.state.status, AuthStatus.authenticated);
    });
  });
}

class _RefreshTestAuthRepository with AuthRepository {
  final _sessionController = StreamController<bool>.broadcast();

  Session? refreshResult;
  Object? refreshError;

  Future<void> dispose() async {
    await _sessionController.close();
  }

  @override
  Future<Session> refreshToken({bool refreshUserExt = false}) async {
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
  Future<(UserExt, Session, UserPresets)?> isAuthenticated() async => null;

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
