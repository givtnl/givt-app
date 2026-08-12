import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/amount_presets/models/user_presets.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/email_signup/cubit/email_signup_cubit.dart';
import 'package:givt_app/features/email_signup/cubit/email_signup_custom.dart';
import 'package:givt_app/features/email_signup/presentation/models/email_signup_uimodel.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeFamilyAuthRepository implements FamilyAuthRepository {
  @override
  Stream<UserExt?> authenticatedUserStream() => const Stream.empty();

  @override
  Future<String> checkEmail({required String email}) async => '';

  @override
  Future<void> checkUserExt({required String email}) async {}

  @override
  UserExt? getCurrentUser() => null;

  @override
  bool hasUserStartedRegistration() => false;

  @override
  Future<void> initAuth() async {}

  @override
  Future<(UserExt, Session, UserPresets)?> isAuthenticated() async => null;

  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<bool> logout() async => true;

  @override
  void onRegistrationCancelled() {}

  @override
  Future<void> onRegistrationFinished() async {}

  @override
  void onRegistrationStarted() {}

  @override
  Future<void> refreshUser() async {}

  @override
  Stream<void> refreshTokenFailedStream() => const Stream.empty();

  @override
  Future<Session> refreshToken() async => Session(
        email: '',
        userGUID: '',
        accessToken: '',
        refreshToken: '',
        expires: '',
        expiresIn: 0,
        isLoggedIn: false,
      );

  @override
  Future<void> registerUser({
    required TempUser tempUser,
    required bool isNewUser,
  }) async {}

  @override
  Stream<void> registrationFinishedStream() => const Stream.empty();

  @override
  Session getStoredSession() => Session(
        email: '',
        userGUID: '',
        accessToken: '',
        refreshToken: '',
        expires: '',
        expiresIn: 0,
        isLoggedIn: false,
      );

  @override
  Future<UserExt> fetchUserExtension(String guid) async =>
      const UserExt(email: '', guid: '', amountLimit: 0);

  @override
  Future<void> updateNotificationId() async {}

  @override
  Future<bool> updateUser({
    required String guid,
    required Map<String, dynamic> newUserExt,
  }) async =>
      true;

  @override
  Future<bool> updateUserExt(Map<String, dynamic> newUserExt) async => true;

  @override
  Future<void> updateNumber(String number) async {}

  @override
  Future<void> updateEmail(String email) async {}
}

EmailSignupUiModel _dataState(EmailSignupCubit cubit) {
  final state = cubit.state;
  expect(state, isA<DataState<EmailSignupUiModel, EmailSignupCustom>>());
  return (state as DataState<EmailSignupUiModel, EmailSignupCustom>).data;
}

void main() {
  group('EmailSignupCubit', () {
    late EmailSignupCubit cubit;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      getIt.allowReassignment = true;
      if (!getIt.isRegistered<SharedPreferences>()) {
        getIt.registerSingleton<SharedPreferences>(
          await SharedPreferences.getInstance(),
        );
      }
    });

    setUp(() {
      cubit = EmailSignupCubit(_FakeFamilyAuthRepository());
    });

    tearDown(() async {
      await cubit.close();
    });

    test('init emits continueButtonEnabled false when country is unset', () async {
      await cubit.init();

      final data = _dataState(cubit);
      expect(data.continueButtonEnabled, isFalse);
    });

    test(
        'updateEmail emits continueButtonEnabled false when country is unset',
        () async {
      await cubit.init();

      await cubit.updateEmail('test@example.com');

      final data = _dataState(cubit);
      expect(data.email, 'test@example.com');
      expect(data.country, isNull);
      expect(data.continueButtonEnabled, isFalse);
    });

    test(
        'updateCountry enables continue when email is valid and country selected',
        () async {
      await cubit.init();
      await cubit.updateEmail('test@example.com');

      await cubit.updateCountry(Country.nl);

      final data = _dataState(cubit);
      expect(data.country, Country.nl);
      expect(data.continueButtonEnabled, isTrue);
    });

    test('updateApi does not throw when country is null', () {
      expect(cubit.updateApi, returnsNormally);
    });

    test('login emits snackbar when country is unset', () async {
      await cubit.init();
      await cubit.updateEmail('test@example.com');

      await cubit.login();

      expect(
        cubit.state,
        isA<SnackbarState<EmailSignupUiModel, EmailSignupCustom>>(),
      );
      final snackbar =
          cubit.state as SnackbarState<EmailSignupUiModel, EmailSignupCustom>;
      expect(snackbar.text, 'Please select a country');
    });
  });
}
