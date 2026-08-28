import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/account_details/pages/change_address_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_bank_details_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_name_bottom_sheet.dart';
import 'package:givt_app/features/account_details/widgets/personal_info_edit_sheet_success.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/design_system/components/actions/fun_button.dart';
import 'package:givt_app/shared/models/bacs_mandate_response.dart';
import 'package:givt_app/shared/models/stripe_response.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/features/amount_presets/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late _FakeAuthRepository repository;
  late AuthCubit authCubit;
  late PersonalInfoEditBloc personalInfoEditBloc;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
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
    final completer = repository.fetchUserExtensionCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete(
        const UserExt(email: '', guid: '', amountLimit: 0),
      );
      await Future<void>.delayed(Duration.zero);
    }
    await personalInfoEditBloc.close();
    await authCubit.close();
    repository.dispose();
  });

  Future<void> pumpSheet(WidgetTester tester, Widget sheet) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PersonalInfoEditBloc>.value(
            value: personalInfoEditBloc,
          ),
          BlocProvider<AuthCubit>.value(value: authCubit),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: sheet),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  FunButton saveButton(WidgetTester tester) {
    return tester.widget<FunButton>(
      find.widgetWithText(FunButton, 'Save'),
    );
  }

  test(
    'resetPersonalInfoEditSheetOnDismiss clears leaked success state',
    () async {
      personalInfoEditBloc.add(
        const PersonalInfoEditName(firstName: 'Jane', lastName: 'Doe'),
      );
      await personalInfoEditBloc.stream.firstWhere(
        (state) => state.status == PersonalInfoEditStatus.success,
      );

      resetPersonalInfoEditSheetOnDismiss(personalInfoEditBloc, authCubit);

      await personalInfoEditBloc.stream.firstWhere(
        (state) => state.status == PersonalInfoEditStatus.initial,
      );
    },
  );

  test(
    'resetPersonalInfoEditSheetOnDismiss applies saved bank details before refreshUser',
    () async {
      const original = UserExt(
        email: 'uk@givt.app',
        guid: 'guid',
        amountLimit: 499,
        country: 'GB',
        sortCode: '123456',
        accountNumber: '12345678',
      );
      authCubit.emit(
        authCubit.state.copyWith(
          status: AuthStatus.authenticated,
          user: original,
        ),
      );
      repository.fetchUserExtensionCompleter = Completer<UserExt>();

      await personalInfoEditBloc.close();
      personalInfoEditBloc = PersonalInfoEditBloc(
        authRepository: repository,
        loggedInUserExt: original,
      );

      personalInfoEditBloc.add(
        const PersonalInfoEditBankDetails(
          iban: '',
          accountNumber: '87654321',
          sortCode: '654321',
        ),
      );
      await personalInfoEditBloc.stream.firstWhere(
        (state) => state.status == PersonalInfoEditStatus.success,
      );

      resetPersonalInfoEditSheetOnDismiss(personalInfoEditBloc, authCubit);

      // refreshUser may already have flipped status to loading; bank
      // details must still be the values just saved.
      expect(authCubit.state.user.sortCode, '654321');
      expect(authCubit.state.user.accountNumber, '87654321');
    },
  );

  testWidgets(
    'completePersonalInfoEditSheet pops without post-pop provider access',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (sheetContext) => TextButton(
                      onPressed: () =>
                          completePersonalInfoEditSheet(sheetContext),
                      child: const Text('Done'),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Done'), findsOneWidget);

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(find.text('Done'), findsNothing);
    },
  );

  testWidgets('name sheet disables save until name changes', (tester) async {
    await pumpSheet(
      tester,
      const ChangeNameBottomSheet(
        firstName: 'John',
        lastName: 'Smith',
      ),
    );

    expect(saveButton(tester).isDisabled, isTrue);

    await tester.enterText(find.byType(TextField).first, 'Jane');
    await tester.pump();

    expect(saveButton(tester).isDisabled, isFalse);
  });

  testWidgets('bank sheet shows IBAN field for SEPA users', (tester) async {
    await pumpSheet(
      tester,
      const ChangeBankDetailsBottomSheet(
        iban: 'NL8610000000124300013',
        accountNumber: '',
        sortCode: '',
      ),
    );

    final context = tester.element(find.byType(ChangeBankDetailsBottomSheet));
    final locals = AppLocalizations.of(context)!;

    expect(find.text(locals.editIbanAccount), findsOneWidget);
    expect(find.text(locals.sortCodePlaceholder), findsNothing);
    expect(saveButton(tester).isDisabled, isTrue);
  });

  testWidgets('bank sheet shows BACS fields for UK users', (tester) async {
    await pumpSheet(
      tester,
      const ChangeBankDetailsBottomSheet(
        iban: '',
        accountNumber: '12345678',
        sortCode: '123456',
      ),
    );

    final context = tester.element(find.byType(ChangeBankDetailsBottomSheet));
    final locals = AppLocalizations.of(context)!;

    expect(find.text(locals.sortCodePlaceholder), findsAtLeastNWidgets(1));
    expect(
      find.text(locals.bankAccountNumberPlaceholder),
      findsAtLeastNWidgets(1),
    );
    expect(find.text(locals.editIbanAccount), findsNothing);
  });

  testWidgets('bank sheet shows 6 and 8 digit validation copy', (tester) async {
    await pumpSheet(
      tester,
      const ChangeBankDetailsBottomSheet(
        iban: '',
        accountNumber: '12345678',
        sortCode: '123456',
      ),
    );

    final context = tester.element(find.byType(ChangeBankDetailsBottomSheet));
    final locals = AppLocalizations.of(context)!;

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(2));

    await tester.enterText(fields.at(0), '12');
    await tester.pump();
    expect(find.text(locals.sortCodeMustBe6Digits), findsOneWidget);

    await tester.enterText(fields.at(1), '123');
    await tester.pump();
    expect(find.text(locals.accountNumberMustBe8Digits), findsOneWidget);
  });

  testWidgets('address sheet shows split fields for Netherlands', (
    tester,
  ) async {
    await pumpSheet(
      tester,
      ChangeAddressBottomSheet(
        address: 'Bongerd 1',
        postalCode: '8212 BJ',
        city: 'Lelystad',
        country: Country.nl.countryCode,
      ),
    );

    final context = tester.element(find.byType(ChangeAddressBottomSheet));
    final locals = AppLocalizations.of(context)!;

    expect(find.text(locals.street), findsAtLeastNWidgets(1));
    expect(find.text(locals.houseNumber), findsAtLeastNWidgets(1));
    expect(find.text(locals.country), findsAtLeastNWidgets(1));
    expect(saveButton(tester).isDisabled, isTrue);
  });

  testWidgets('address sheet shows single address field for UK', (
    tester,
  ) async {
    await pumpSheet(
      tester,
      ChangeAddressBottomSheet(
        address: '1 High Street',
        postalCode: 'B3 1RD',
        city: 'Birmingham',
        country: Country.gb.countryCode,
      ),
    );

    final context = tester.element(find.byType(ChangeAddressBottomSheet));
    final locals = AppLocalizations.of(context)!;

    expect(find.text(locals.address), findsAtLeastNWidgets(1));
    expect(find.text(locals.street), findsNothing);
    expect(find.text(locals.houseNumber), findsNothing);
  });
}

class _FakeAuthRepository with AuthRepository {
  final _sessionController = StreamController<bool>.broadcast();
  Completer<UserExt>? fetchUserExtensionCompleter;

  void dispose() {
    _sessionController.close();
  }

  @override
  Future<BacsMandateResponse> updatePendingBacsBankDetails({
    required String guid,
    required String sortCode,
    required String accountNumber,
  }) async => BacsMandateResponse(
    sortCode: sortCode,
    accountNumber: accountNumber,
  );

  @override
  Future<Session> refreshToken({bool refreshUserExt = false}) async =>
      const Session.empty();

  @override
  Future<Session> login(String email, String password) async =>
      const Session.empty();

  @override
  Future<UserExt> fetchUserExtension(String guid) async {
    final completer = fetchUserExtensionCompleter;
    if (completer != null) {
      return completer.future;
    }
    return const UserExt(email: '', guid: '', amountLimit: 0);
  }

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
