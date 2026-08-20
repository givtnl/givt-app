import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/external_donations/detail/cubit/external_donation_detail_cubit.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_history_item.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_update_scope.dart';
import 'package:givt_app/features/external_donations/detail/pages/external_donation_detail_page.dart';
import 'package:givt_app/features/external_donations/detail/repositories/external_donation_detail_repository.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_schedule.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/design_system/components/content/fun_tag.dart';
import 'package:givt_app/shared/models/user_ext.dart';

class _FakeAuthRepository with AuthRepository {
  final _sessionController = StreamController<bool>.broadcast();

  @override
  Stream<bool> hasSessionStream() => _sessionController.stream;

  void dispose() {
    _sessionController.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeExternalDonationDetailRepository
    with ExternalDonationDetailRepository {
  ExternalDonation? _donation;

  @override
  bool isLoading() => false;

  @override
  String? getError() => null;

  @override
  ExternalDonation? getDonation() => _donation;

  @override
  double getTotalDonated() => _donation?.amount ?? 0;

  @override
  GivingDuration? getGivingDuration() =>
      const GivingDuration(1, GivingDurationUnit.days);

  @override
  List<ExternalDonationHistoryItem> getHistory() => const [];

  void setDonation(ExternalDonation donation) {
    _donation = donation;
  }

  @override
  Future<void> loadDetail(ExternalDonation donation) async {
    _donation = donation;
  }

  @override
  Future<bool> stopDonation(String externalDonationId) async => true;

  @override
  Future<bool> updateAmount({
    required String externalDonationId,
    required double amount,
    ExternalDonationUpdateScope? scope,
  }) async =>
      true;

  @override
  Future<bool> updateFrequency({
    required String externalDonationId,
    required ExternalDonationFrequency frequency,
    required DateTime anchorDate,
    ExternalDonationUpdateScope? scope,
  }) async =>
      true;

  @override
  Future<bool> updateStartDate({
    required String externalDonationId,
    required DateTime startDate,
  }) async =>
      true;

  @override
  Future<bool> updateOneOff({
    required String externalDonationId,
    double? amount,
    DateTime? date,
  }) async =>
      true;

  @override
  Future<bool> deleteDonation(String externalDonationId) async => true;

  @override
  Future<bool> bulkUpdateTransactions({
    required List<String> transactionIds,
    required double newAmount,
  }) async =>
      true;

  @override
  Future<bool> bulkDeleteTransactions({
    required List<String> transactionIds,
  }) async =>
      true;
}

void main() {
  late _FakeExternalDonationDetailRepository repository;
  late _FakeAuthRepository authRepository;
  late AuthCubit authCubit;

  setUp(() {
    repository = _FakeExternalDonationDetailRepository();

    if (getIt.isRegistered<ExternalDonationDetailCubit>()) {
      getIt.unregister<ExternalDonationDetailCubit>();
    }
    getIt.registerFactory<ExternalDonationDetailCubit>(
      () => ExternalDonationDetailCubit(repository),
    );

    authRepository = _FakeAuthRepository();
    authCubit = AuthCubit(authRepository);
    authCubit.emit(
      authCubit.state.copyWith(
        status: AuthStatus.authenticated,
        user: const UserExt(
          email: 'test@givt.app',
          guid: 'guid',
          amountLimit: 499,
          country: 'NL',
        ),
      ),
    );
  });

  tearDown(() async {
    await authCubit.close();
    authRepository.dispose();
    if (getIt.isRegistered<ExternalDonationDetailCubit>()) {
      await getIt.unregister<ExternalDonationDetailCubit>();
    }
  });

  Future<void> pumpDetailPage(
    WidgetTester tester,
    ExternalDonation donation,
  ) async {
    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ExternalDonationDetailPage(donation: donation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('one-off detail page renders FunTag without recurring icon',
      (tester) async {
    const donation = ExternalDonation(
      id: 'donation-one-off',
      amount: 20,
      description: 'World Vision',
      frequencyString: 'Once',
      creationDate: '2024-01-01T00:00:00.000Z',
      taxDeductible: false,
      startDate: '2024-06-15T00:00:00.000Z',
    );
    repository.setDonation(donation);

    await pumpDetailPage(tester, donation);

    final tag = tester.widget<FunTag>(find.byType(FunTag));
    expect(tag.iconData, isNull);
  });

  testWidgets('recurring detail page renders FunTag with recurring icon',
      (tester) async {
    const donation = ExternalDonation(
      id: 'donation-recurring',
      amount: 20,
      description: 'World Vision',
      frequencyString: 'Monthly',
      creationDate: '2024-01-01T00:00:00.000Z',
      taxDeductible: false,
      startDate: '2024-06-15T00:00:00.000Z',
    );
    repository.setDonation(donation);

    await pumpDetailPage(tester, donation);

    final tag = tester.widget<FunTag>(find.byType(FunTag));
    expect(tag.iconData, FontAwesomeIcons.arrowsRotate);
    expect(tag.iconSize, 12);
    expect(tag.variant, FunTagVariant.accent);
  });
}
