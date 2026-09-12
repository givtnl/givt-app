import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/donation_overview/cubit/donation_overview_cubit.dart';
import 'package:givt_app/features/donation_overview/cubit/external_donation_history_detail_cubit.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_mapper.dart';
import 'package:givt_app/features/donation_overview/pages/external_donation_history_detail_page.dart';
import 'package:givt_app/features/donation_overview/repositories/donation_overview_repository.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

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

class _FakeGivtRepository with GivtRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeDonationOverviewRepository with DonationOverviewRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ExternalDonationHistoryDetailPage', () {
    late _FakeAuthRepository authRepository;
    late AuthCubit authCubit;

    setUp(() {
      authRepository = _FakeAuthRepository();
      authCubit = AuthCubit(authRepository);
      authCubit.emit(
        authCubit.state.copyWith(
          status: AuthStatus.authenticated,
          user: const UserExt(
            guid: 'guid',
            email: 'user@example.com',
            amountLimit: 499,
            country: 'NL',
          ),
        ),
      );

      if (getIt.isRegistered<ExternalDonationHistoryDetailCubit>()) {
        getIt.unregister<ExternalDonationHistoryDetailCubit>();
      }
      if (getIt.isRegistered<DonationOverviewCubit>()) {
        getIt.unregister<DonationOverviewCubit>();
      }

      getIt.registerFactory<ExternalDonationHistoryDetailCubit>(
        () => ExternalDonationHistoryDetailCubit(_FakeGivtRepository()),
      );
      getIt.registerFactory<DonationOverviewCubit>(
        () => DonationOverviewCubit(_FakeDonationOverviewRepository()),
      );
    });

    tearDown(() async {
      await authCubit.close();
      authRepository.dispose();
      if (getIt.isRegistered<ExternalDonationHistoryDetailCubit>()) {
        getIt.unregister<ExternalDonationHistoryDetailCubit>();
      }
      if (getIt.isRegistered<DonationOverviewCubit>()) {
        getIt.unregister<DonationOverviewCubit>();
      }
    });

    Future<void> pumpPage(
      WidgetTester tester, {
      required Map<String, dynamic> json,
    }) async {
      final donation = DonationHistoryMapper.fromHistoryJson(json);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AuthCubit>.value(
            value: authCubit,
            child: ExternalDonationHistoryDetailPage(donation: donation),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('renders one-off external copy and edit action', (tester) async {
      await pumpPage(
        tester,
        json: {
          'source': 'external',
          'id': 'tx-1',
          'externalDonationId': 'series-1',
          'externalTransactionId': 'tx-1',
          'amount': 20,
          'timestamp': '2026-03-10T09:00:00',
          'organisationName': 'Food Bank',
          'frequency': 'Once',
          'isRecurring': false,
        },
      );

      expect(
        find.text('External donation: not processed by Givt'),
        findsOneWidget,
      );
      expect(find.text('External donation'), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);
      expect(find.text('Edit this donation'), findsOneWidget);
      expect(find.text('Manage recurring donation'), findsNothing);
    });

    testWidgets('renders recurring occurrence copy and manage action',
        (tester) async {
      await pumpPage(
        tester,
        json: {
          'source': 'external',
          'id': 'tx-2',
          'externalDonationId': 'series-2',
          'externalTransactionId': 'tx-2',
          'amount': 30,
          'timestamp': '2026-03-11T09:00:00',
          'organisationName': 'Shelter',
          'frequency': 'Monthly',
          'isRecurring': true,
        },
      );

      expect(find.text('Not processed by Givt'), findsOneWidget);
      expect(find.text('External donation'), findsOneWidget);
      expect(find.text('Recurring donation'), findsOneWidget);
      expect(find.text('Manage recurring donation'), findsOneWidget);
    });
  });
}
