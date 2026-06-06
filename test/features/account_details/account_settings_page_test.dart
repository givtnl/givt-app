import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/account_details/pages/personal_info_edit_page.dart';
import 'package:givt_app/features/account_details/widgets/account_settings_avatar.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/models/stripe_response.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/features/amount_presets/models/models.dart';

void main() {
  late _FakeAuthRepository repository;
  late AuthCubit authCubit;
  late PersonalInfoEditBloc personalInfoEditBloc;

  setUp(() {
    repository = _FakeAuthRepository();
    authCubit = AuthCubit(repository);
    personalInfoEditBloc = PersonalInfoEditBloc(
      authRepository: repository,
      loggedInUserExt: const UserExt(
        email: 'user@givt.app',
        guid: 'guid',
        amountLimit: 100,
        country: 'NL',
      ),
    );
  });

  tearDown(() async {
    await personalInfoEditBloc.close();
    await authCubit.close();
    repository.dispose();
  });

  Future<AppLocalizations> pumpPage(
    WidgetTester tester,
    UserExt user,
  ) async {
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
          BlocProvider<PersonalInfoEditBloc>.value(
            value: personalInfoEditBloc,
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: PersonalInfoEditPage(),
        ),
      ),
    );
    await tester.pump();
    final context = tester.element(find.byType(PersonalInfoEditPage));
    return AppLocalizations.of(context);
  }

  testWidgets('shows account settings layout for NL registered user', (
    tester,
  ) async {
    final locals = await pumpPage(
      tester,
      const UserExt(
        email: 'user@givt.app',
        guid: 'guid',
        amountLimit: 100,
        country: 'NL',
        needRegistration: false,
        mandateSigned: true,
        firstName: 'John',
        lastName: 'Smith',
        iban: 'NL8610000000124300013',
      ),
    );

    expect(find.text(locals.accountSettingsTitle), findsOneWidget);
    expect(find.text(locals.accountSettingsPersonalDetails), findsOneWidget);
    expect(find.text(locals.accountSettingsSecurity), findsOneWidget);
    expect(find.text(locals.accountSettingsPreferences), findsOneWidget);
    expect(find.text('NL8610000000124300013'), findsOneWidget);
    expect(find.text('Gift Aid'), findsNothing);
    expect(find.text(locals.giveLimit), findsOneWidget);
    expect(find.text(locals.unregister), findsOneWidget);
  });

  testWidgets('shows Gift Aid and BACs formatting for UK user', (tester) async {
    await pumpPage(
      tester,
      const UserExt(
        email: 'uk@givt.app',
        guid: 'guid',
        amountLimit: 100,
        country: 'GB',
        needRegistration: false,
        mandateSigned: true,
        sortCode: '123456',
        accountNumber: '12345678',
      ),
    );

    expect(find.text('Gift Aid'), findsOneWidget);
    expect(find.textContaining('12-34-56'), findsOneWidget);
  });

  testWidgets('shows US card details instead of IBAN', (tester) async {
    await pumpPage(
      tester,
      const UserExt(
        email: 'us@givt.app',
        guid: 'guid',
        amountLimit: 100,
        country: 'US',
        needRegistration: false,
        mandateSigned: true,
        accountBrand: 'visa',
        accountNumber: '4242',
      ),
    );

    expect(find.text('VISA 4242'), findsOneWidget);
    expect(find.textContaining('NL86'), findsNothing);
  });

  testWidgets('hides preferences when registration is incomplete', (
    tester,
  ) async {
    final locals = await pumpPage(
      tester,
      const UserExt(
        email: 'user@givt.app',
        guid: 'guid',
        amountLimit: 100,
        country: 'NL',
        needRegistration: true,
        mandateSigned: true,
      ),
    );

    expect(find.text(locals.accountSettingsPreferences), findsNothing);
    expect(find.text(locals.giveLimit), findsNothing);
  });

  testWidgets('EU user sees static placeholder without avatar editing', (
    tester,
  ) async {
    await pumpPage(
      tester,
      const UserExt(
        email: 'user@givt.app',
        guid: 'guid',
        amountLimit: 100,
        country: 'NL',
        needRegistration: false,
        mandateSigned: true,
        profilePicture: 'Hero3.svg',
      ),
    );

    expect(find.byType(AccountSettingsAvatar), findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.pen), findsNothing);
  });

  testWidgets('US user can edit profile avatar when picture is set', (
    tester,
  ) async {
    await pumpPage(
      tester,
      const UserExt(
        email: 'us@givt.app',
        guid: 'guid',
        amountLimit: 100,
        country: 'US',
        needRegistration: false,
        mandateSigned: true,
        profilePicture: 'Hero3.svg',
      ),
    );

    expect(find.byType(AccountSettingsAvatar), findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.pen), findsOneWidget);
  });

  testWidgets('bank row is not tappable when mandate is unsigned', (
    tester,
  ) async {
    await pumpPage(
      tester,
      const UserExt(
        email: 'user@givt.app',
        guid: 'guid',
        amountLimit: 100,
        country: 'NL',
        needRegistration: false,
        mandateSigned: false,
        iban: 'NL8610000000124300013',
      ),
    );

    final chevrons = find.byIcon(FontAwesomeIcons.chevronRight);
    expect(chevrons, findsWidgets);
    expect(tester.widgetList(chevrons).length, lessThan(10));
  });
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
