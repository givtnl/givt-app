import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/shared/models/bacs_mandate_response.dart';
import 'package:givt_app/shared/models/stripe_response.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/features/amount_presets/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeAuthRepository repository;
  late AuthCubit authCubit;
  late RegistrationBloc bloc;

  const ukUser = UserExt(
    email: 'uk@givt.app',
    guid: 'existing-guid',
    amountLimit: 499,
    country: 'GB',
    sortCode: '12-34-56',
    accountNumber: '12345678',
  );

  const nlUser = UserExt(
    email: 'nl@givt.app',
    guid: 'existing-guid',
    amountLimit: 499,
    country: 'NL',
    iban: 'NL8610000000124300013',
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await GetIt.instance.reset();
    GetIt.instance.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance(),
    );
    repository = _FakeAuthRepository();
    authCubit = AuthCubit(repository);
    bloc = RegistrationBloc(
      authRepositoy: repository,
      authCubit: authCubit,
    );
  });

  tearDown(() async {
    await bloc.close();
    await authCubit.close();
    repository.dispose();
    await GetIt.instance.reset();
  });

  void emitUser(UserExt user) {
    authCubit.emit(
      authCubit.state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  test('UK sign patches BACS then signs with the existing GUID', () async {
    emitUser(ukUser);
    repository.fetchUser = ukUser;

    bloc.add(
      const RegistrationSignMandate(
        guid: 'existing-guid',
        appLanguage: 'en',
      ),
    );

    await expectLater(
      bloc.stream,
      emitsThrough(
        predicate<RegistrationState>(
          (state) =>
              state.status == RegistrationStatus.bacsDirectDebitMandateSigned,
        ),
      ),
    );

    expect(repository.bacsGuids, ['existing-guid']);
    expect(repository.bacsSortCodes, ['123456']);
    expect(repository.bacsAccountNumbers, ['12345678']);
    expect(repository.signGuids, ['existing-guid']);
    expect(repository.updateUserExtCalls, 0);
  });

  test(
    'UK BACS 400 keeps the existing GUID and emits bacsDetailsWrong',
    () async {
      emitUser(ukUser);
      repository.bacsError = const GivtServerFailure(
        statusCode: 400,
        body: {'errorMessage': 'Sort code must be 6 digits'},
      );

      bloc.add(
        const RegistrationSignMandate(
          guid: 'existing-guid',
          appLanguage: 'en',
        ),
      );

      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<RegistrationState>(
            (state) =>
                state.status == RegistrationStatus.bacsDetailsWrong &&
                state.errorMessage == 'Sort code must be 6 digits',
          ),
        ),
      );

      expect(repository.bacsGuids, ['existing-guid']);
      expect(repository.signGuids, isEmpty);
    },
  );

  test('UK 409 MANDATE_ALREADY_SIGNED emits signed status', () async {
    emitUser(ukUser);
    repository.fetchUser = ukUser.copyWith(mandateSigned: true);
    repository.bacsError = const GivtServerFailure(
      statusCode: 409,
      body: {'errorMessage': 'MANDATE_ALREADY_SIGNED: closed.completed'},
    );

    bloc.add(
      const RegistrationSignMandate(
        guid: 'existing-guid',
        appLanguage: 'en',
      ),
    );

    await expectLater(
      bloc.stream,
      emitsThrough(
        predicate<RegistrationState>(
          (state) =>
              state.status == RegistrationStatus.bacsDirectDebitMandateSigned,
        ),
      ),
    );

    expect(repository.signGuids, isEmpty);
  });

  test('non-UK sign does not call the pending BACS endpoint', () async {
    emitUser(nlUser);
    repository.fetchUser = nlUser;

    bloc.add(
      const RegistrationSignMandate(
        guid: 'existing-guid',
        appLanguage: 'en',
      ),
    );

    await expectLater(
      bloc.stream,
      emitsThrough(
        predicate<RegistrationState>(
          (state) => state.status == RegistrationStatus.success,
        ),
      ),
    );

    expect(repository.bacsGuids, isEmpty);
    expect(repository.signGuids, ['existing-guid']);
  });
}

class _FakeAuthRepository with AuthRepository {
  final _sessionController = StreamController<bool>.broadcast();
  final bacsGuids = <String>[];
  final bacsSortCodes = <String>[];
  final bacsAccountNumbers = <String>[];
  final signGuids = <String>[];
  Object? bacsError;
  UserExt fetchUser = const UserExt(email: '', guid: '', amountLimit: 0);
  int updateUserExtCalls = 0;

  void dispose() {
    _sessionController.close();
  }

  @override
  Future<BacsMandateResponse> updatePendingBacsBankDetails({
    required String guid,
    required String sortCode,
    required String accountNumber,
  }) async {
    bacsGuids.add(guid);
    bacsSortCodes.add(sortCode);
    bacsAccountNumbers.add(accountNumber);
    final error = bacsError;
    if (error is Exception) {
      throw error;
    }
    if (error != null) {
      throw Exception(error);
    }
    return BacsMandateResponse(
      sortCode: sortCode,
      accountNumber: accountNumber,
    );
  }

  @override
  Future<Session> refreshToken({bool refreshUserExt = false}) async =>
      const Session.empty();

  @override
  Future<Session> login(String email, String password) async =>
      const Session.empty();

  @override
  Future<UserExt> fetchUserExtension(String guid) async => fetchUser;

  @override
  Future<(UserExt, Session, UserPresets)?> isAuthenticated() async => (
    fetchUser,
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
  }) async {
    signGuids.add(guid);
    return '';
  }

  @override
  Future<StripeResponse> fetchStripeSetupIntent() async =>
      const StripeResponse.empty();

  @override
  Future<UserExt> registerUser({
    required TempUser tempUser,
    required bool isNewUser,
  }) async => fetchUser;

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
  Future<bool> updateUserExt(Map<String, dynamic> newUserExt) async {
    updateUserExtCalls++;
    return true;
  }

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
