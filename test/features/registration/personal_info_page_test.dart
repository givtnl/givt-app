import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/pages/personal_info_page.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/stripe_response.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/features/amount_presets/models/models.dart';

void main() {
  testWidgets(
    'changing phone area code keeps UK payment fields',
    (tester) async {
      final repository = _FakeAuthRepository();
      final authCubit = AuthCubit(repository);
      final registrationBloc = RegistrationBloc(
        authRepositoy: repository,
        authCubit: authCubit,
      );

      addTearDown(() async {
        await authCubit.close();
        await registrationBloc.close();
        repository.dispose();
      });

      final user = UserExt(
        email: 'uk@givt.app',
        guid: 'guid',
        amountLimit: 499,
        country: Country.gb.countryCode,
      );

      authCubit.emit(
        authCubit.state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ),
      );

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>.value(value: authCubit),
            BlocProvider<RegistrationBloc>.value(value: registrationBloc),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: PersonalInfoPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final pageContext = tester.element(find.byType(PersonalInfoPage));
      final locals = AppLocalizations.of(pageContext);

      expect(find.text(locals.sortCodePlaceholder), findsOneWidget);

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('+31').last);
      await tester.pumpAndSettle();

      expect(find.text(locals.sortCodePlaceholder), findsOneWidget);
      expect(find.text(locals.ibanPlaceHolder), findsNothing);
    },
  );
}

class _FakeAuthRepository with AuthRepository {
  final _sessionController = StreamController<bool>.broadcast();

  void dispose() {
    _sessionController.close();
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
  Future<(UserExt, Session, UserPresets)?> isAuthenticated() async => (
        const UserExt(email: '', guid: '', amountLimit: 0),
        const Session.empty(),
        const UserPresets.empty(),
      );

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
