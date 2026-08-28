import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/shared/models/bacs_mandate_response.dart';
import 'package:givt_app/shared/models/stripe_response.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/features/amount_presets/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeAuthRepository repository;
  late PersonalInfoEditBloc bloc;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await bloc.close();
    repository.dispose();
  });

  PersonalInfoEditBloc createBloc(UserExt user) {
    repository = _FakeAuthRepository();
    return PersonalInfoEditBloc(
      authRepository: repository,
      loggedInUserExt: user,
    );
  }

  test(
    'unsigned UK bank save uses pending BACS endpoint not updateUserExt',
    () async {
      bloc = createBloc(
        const UserExt(
          email: 'uk@givt.app',
          guid: 'existing-guid',
          amountLimit: 499,
          country: 'GB',
          sortCode: '123456',
          accountNumber: '12345678',
        ),
      );

      bloc.add(
        const PersonalInfoEditBankDetails(
          iban: '',
          accountNumber: '87654321',
          sortCode: '654321',
        ),
      );

      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<PersonalInfoEditState>(
            (state) =>
                state.status == PersonalInfoEditStatus.success &&
                state.loggedInUserExt.sortCode == '654321' &&
                state.loggedInUserExt.accountNumber == '87654321',
          ),
        ),
      );

      expect(repository.bacsGuids, ['existing-guid']);
      expect(repository.updateUserExtCalls, 0);
    },
  );

  test('signed UK bank save uses updateUserExt', () async {
    bloc = createBloc(
      const UserExt(
        email: 'uk@givt.app',
        guid: 'existing-guid',
        amountLimit: 499,
        country: 'GB',
        mandateSigned: true,
        sortCode: '123456',
        accountNumber: '12345678',
      ),
    );

    bloc.add(
      const PersonalInfoEditBankDetails(
        iban: '',
        accountNumber: '87654321',
        sortCode: '654321',
      ),
    );

    await expectLater(
      bloc.stream,
      emitsThrough(
        predicate<PersonalInfoEditState>(
          (state) => state.status == PersonalInfoEditStatus.success,
        ),
      ),
    );

    expect(repository.bacsGuids, isEmpty);
    expect(repository.updateUserExtCalls, 1);
  });

  test(
    'unsigned UK 409 MANDATE_ALREADY_SIGNED emits mandateAlreadySigned',
    () async {
      bloc = createBloc(
        const UserExt(
          email: 'uk@givt.app',
          guid: 'existing-guid',
          amountLimit: 499,
          country: 'GB',
          sortCode: '123456',
          accountNumber: '12345678',
        ),
      );
      repository.bacsError = const GivtServerFailure(
        statusCode: 409,
        body: {'errorMessage': 'MANDATE_ALREADY_SIGNED: open.running'},
      );

      bloc.add(
        const PersonalInfoEditBankDetails(
          iban: '',
          accountNumber: '87654321',
          sortCode: '654321',
        ),
      );

      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<PersonalInfoEditState>(
            (state) =>
                state.status == PersonalInfoEditStatus.mandateAlreadySigned,
          ),
        ),
      );
    },
  );
}

class _FakeAuthRepository with AuthRepository {
  final _sessionController = StreamController<bool>.broadcast();
  final bacsGuids = <String>[];
  Object? bacsError;
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
