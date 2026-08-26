import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/features/amount_presets/models/models.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/auth/pages/login_page.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/models/stripe_response.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/utils/auth_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeAuthRepository repository;
  late _RecordingAuthCubit cubit;
  late _FakeNetworkInfo networkInfo;
  var navigateCount = 0;

  const user = UserExt(
    email: 'user@givt.app',
    guid: 'guid-1',
    amountLimit: 499,
  );

  Session validSession() {
    return Session(
      email: user.email,
      userGUID: user.guid,
      accessToken: 'access',
      refreshToken: 'refresh',
      expires: DateTime.now()
          .toUtc()
          .add(const Duration(minutes: 30))
          .toIso8601String(),
      expiresIn: 1800,
      isLoggedIn: true,
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = _FakeAuthRepository();
    cubit = _RecordingAuthCubit(repository);
    cubit.emit(
      cubit.state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        session: validSession(),
      ),
    );
    networkInfo = _FakeNetworkInfo(isConnected: true);
    if (getIt.isRegistered<NetworkInfo>()) {
      await getIt.unregister<NetworkInfo>();
    }
    getIt.registerSingleton<NetworkInfo>(networkInfo);
    navigateCount = 0;
  });

  tearDown(() async {
    await cubit.close();
    repository.dispose();
    if (getIt.isRegistered<NetworkInfo>()) {
      await getIt.unregister<NetworkInfo>();
    }
  });

  Future<void> runCheckToken(
    WidgetTester tester, {
    CheckAuthPolicy policy = CheckAuthPolicy.ensureSession,
  }) async {
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('overflowed')) {
        return;
      }
      previousOnError?.call(details);
    };
    addTearDown(() {
      FlutterError.onError = previousOnError;
    });

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: cubit,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  unawaited(
                    AuthUtils.checkToken(
                      context,
                      checkAuthRequest: CheckAuthRequest(
                        policy: policy,
                        navigate: (_) async {
                          navigateCount++;
                        },
                      ),
                    ),
                  );
                },
                child: const Text('Continue'),
              );
            },
          ),
        ),
      ),
    );
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  group('AuthUtils.checkToken auth gate', () {
    testWidgets(
      'ensureSession navigates without refresh when token is valid',
      (tester) async {
        await runCheckToken(tester);

        expect(cubit.refreshCallCount, 0);
        expect(navigateCount, 1);
      },
    );

    testWidgets(
      'stepUp does not navigate when grace has elapsed',
      (tester) async {
        await runCheckToken(tester, policy: CheckAuthPolicy.stepUp);

        expect(cubit.refreshCallCount, 0);
        expect(navigateCount, 0);
      },
    );

    testWidgets(
      'stepUp navigates without refresh when within grace and token is valid',
      (tester) async {
        await repository.markLocalAuthSucceeded();

        await runCheckToken(tester, policy: CheckAuthPolicy.stepUp);

        expect(cubit.refreshCallCount, 0);
        expect(navigateCount, 1);
      },
    );

    testWidgets(
      'ensureSession forces refresh when reauthentication is needed',
      (tester) async {
        cubit
          ..emit(
            cubit.state.copyWith(
              status: AuthStatus.authenticated,
              user: user,
              session: validSession(),
              needsReauthentication: true,
            ),
          )
          ..refreshResult = RefreshSessionResult.failure;

        await runCheckToken(tester);

        expect(cubit.refreshCallCount, 1);
        expect(cubit.lastForce, isTrue);
        expect(navigateCount, 0);
      },
    );

    testWidgets(
      'stepUp refreshes then navigates when reauthentication is needed within grace',
      (tester) async {
        await repository.markLocalAuthSucceeded();
        cubit.emit(
          cubit.state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            session: validSession(),
            needsReauthentication: true,
          ),
        );

        await runCheckToken(tester, policy: CheckAuthPolicy.stepUp);

        expect(cubit.refreshCallCount, 1);
        expect(navigateCount, 1);
      },
    );

    testWidgets(
      'ensureSession does not show login when refresh token is invalid',
      (tester) async {
        cubit
          ..emit(
            cubit.state.copyWith(
              status: AuthStatus.authenticated,
              user: user,
              session: validSession(),
              needsReauthentication: true,
            ),
          )
          ..refreshResult = RefreshSessionResult.invalidRefreshToken;

        await runCheckToken(tester);

        expect(cubit.refreshCallCount, 1);
        expect(navigateCount, 0);
        expect(find.byType(LoginPage), findsNothing);
      },
    );
  });
}

class _FakeNetworkInfo with NetworkInfo {
  _FakeNetworkInfo({required this.isConnected});

  @override
  bool isConnected;

  final _controller = StreamController<bool>.broadcast();

  @override
  Stream<bool> hasInternetConnectionStream() => _controller.stream.distinct();
}

class _RecordingAuthCubit extends AuthCubit {
  _RecordingAuthCubit(super.repository);

  int refreshCallCount = 0;
  bool? lastForce;
  RefreshSessionResult refreshResult = RefreshSessionResult.success;

  @override
  Future<RefreshSessionResult> refreshSession({
    bool emitAuthentication = true,
    bool force = false,
  }) async {
    refreshCallCount++;
    lastForce = force;
    return refreshResult;
  }
}

class _FakeAuthRepository with AuthRepository {
  final _sessionController = StreamController<bool>.broadcast();
  DateTime? _lastLocalAuthAt;

  void dispose() {
    _sessionController.close();
  }

  @override
  DateTime? lastLocalAuthAt() => _lastLocalAuthAt;

  @override
  Future<void> markLocalAuthSucceeded({DateTime? at}) async {
    _lastLocalAuthAt = (at ?? DateTime.now()).toUtc();
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
