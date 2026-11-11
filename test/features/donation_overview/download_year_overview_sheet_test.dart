import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/donation_overview/cubit/donation_overview_cubit.dart';
import 'package:givt_app/features/donation_overview/models/donation_group.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_filters.dart';
import 'package:givt_app/features/donation_overview/models/donation_overview_uimodel.dart';
import 'package:givt_app/features/donation_overview/repositories/donation_overview_repository.dart';
import 'package:givt_app/features/donation_overview/widgets/download_year_overview_sheet.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:go_router/go_router.dart';

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

class _UnusedDonationOverviewRepository with DonationOverviewRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RecordingOverviewCubit extends DonationOverviewCubit {
  _RecordingOverviewCubit() : super(_UnusedDonationOverviewRepository());

  String? downloadedYear;

  @override
  Future<void> downloadYearlyOverview({required String year}) async {
    downloadedYear = year;
  }
}

void main() {
  group('DownloadYearOverviewSheet', () {
    late _FakeAuthRepository authRepository;
    late AuthCubit authCubit;
    late _RecordingOverviewCubit overviewCubit;

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
      overviewCubit = _RecordingOverviewCubit();
    });

    tearDown(() async {
      await overviewCubit.close();
      await authCubit.close();
      authRepository.dispose();
    });

    testWidgets('opens on the filtered calendar year', (tester) async {
      final filteredYear = DateTime.now().year - 1;
      await _openSheet(
        tester,
        authCubit: authCubit,
        overviewCubit: overviewCubit,
        uiModel: _uiModel(
          filters: _yearRange(filteredYear),
          years: [filteredYear],
        ),
      );

      expect(find.text('$filteredYear'), findsOneWidget);
      expect(find.text('${DateTime.now().year}'), findsNothing);
    });

    testWidgets('keeps a newly chosen year when sending', (tester) async {
      final filteredYear = DateTime.now().year - 1;
      final otherYear = filteredYear - 1;
      await _openSheet(
        tester,
        authCubit: authCubit,
        overviewCubit: overviewCubit,
        uiModel: _uiModel(
          filters: _yearRange(filteredYear),
          years: [filteredYear, otherYear],
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('$otherYear').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();

      expect(overviewCubit.downloadedYear, '$otherYear');
    });

    testWidgets('offers the filter year when that year has no gifts', (
      tester,
    ) async {
      final filteredYear = DateTime.now().year - 1;
      await _openSheet(
        tester,
        authCubit: authCubit,
        overviewCubit: overviewCubit,
        uiModel: _uiModel(
          filters: _yearRange(filteredYear),
          years: const [],
        ),
      );

      expect(find.text('$filteredYear'), findsOneWidget);
      expect(find.text('${DateTime.now().year}'), findsNothing);
    });

    testWidgets('uses the current year when history has no date filter', (
      tester,
    ) async {
      final currentYear = DateTime.now().year;
      await _openSheet(
        tester,
        authCubit: authCubit,
        overviewCubit: overviewCubit,
        uiModel: _uiModel(
          filters: DonationHistoryFilters.empty,
          years: [currentYear, currentYear - 1],
        ),
      );

      expect(find.text('$currentYear'), findsOneWidget);
    });

    testWidgets('does not treat a range across January as one year', (
      tester,
    ) async {
      final currentYear = DateTime.now().year;
      await _openSheet(
        tester,
        authCubit: authCubit,
        overviewCubit: overviewCubit,
        uiModel: _uiModel(
          filters: DonationHistoryFilters.empty.setCustomDates(
            startDate: DateTime(currentYear - 1, 11),
            endDate: DateTime(currentYear, 1, 15),
          ),
          years: [currentYear, currentYear - 1],
        ),
      );

      expect(find.text('$currentYear'), findsOneWidget);
      expect(find.text('${currentYear - 1}'), findsNothing);
    });
  });
}

DonationHistoryFilters _yearRange(int year) {
  return DonationHistoryFilters.empty.setCustomDates(
    startDate: DateTime(year),
    endDate: DateTime(year, 12, 31),
  );
}

DonationOverviewUIModel _uiModel({
  required DonationHistoryFilters filters,
  required List<int> years,
}) {
  return DonationOverviewUIModel(
    donations: const [],
    isLoading: false,
    error: null,
    giftAidAmount: 0,
    monthlyGroups: [
      for (final year in years)
        MonthlyGroup(
          year: year,
          month: 6,
          donations: const [],
          totalAmount: 0,
        ),
    ],
    donationGroups: const <DonationGroup>[],
    filters: filters,
  );
}

Future<void> _openSheet(
  WidgetTester tester, {
  required AuthCubit authCubit,
  required DonationOverviewCubit overviewCubit,
  required DonationOverviewUIModel uiModel,
}) async {
  tester.view.physicalSize = const Size(400, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    BlocProvider<AuthCubit>.value(
      value: authCubit,
      child: MaterialApp.router(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => Scaffold(
                body: TextButton(
                  onPressed: () => DownloadYearOverviewSheet.show(
                    context,
                    uiModel,
                    overviewCubit,
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}
