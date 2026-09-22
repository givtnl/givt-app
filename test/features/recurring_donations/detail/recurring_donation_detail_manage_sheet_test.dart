import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/recurring_donations/detail/cubit/recurring_donation_detail_cubit.dart';
import 'package:givt_app/features/recurring_donations/detail/repositories/recurring_donation_detail_repository.dart';
import 'package:givt_app/features/recurring_donations/detail/widgets/recurring_donation_detail_manage_sheet.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/overview/repositories/recurring_donations_overview_repository.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/design_system/components/actions/fun_button.dart';

class _FakeRecurringDonationDetailRepository
    with RecurringDonationDetailRepository {
  @override
  bool isLoading() => false;

  @override
  String? getError() => null;

  @override
  Future<void> loadRecurringDonationDetail() async {}

  @override
  void setRecurringDonation(RecurringDonation donation) {}

  @override
  String getOrganizationName() => 'Test Org';

  @override
  double getTotalDonated() => 0;

  @override
  String getRemainingTime() => '';

  @override
  DateTime? getEndDate() => null;

  @override
  List<DonationHistoryItem> getHistory() => const [];

  @override
  int getMonthsHelped() => 0;

  @override
  DonationProgress? getProgress() => null;

  @override
  bool isRecurringDonationActive() => true;

  @override
  CollectGroupType getOrganisationType() => CollectGroupType.none;

  @override
  RecurringDonation? getRecurringDonation() => null;

  @override
  Future<void> pauseDonation({required DateTime restartDate}) async {}
}

class _FakeRecurringDonationsOverviewRepository
    with RecurringDonationsOverviewRepository {
  @override
  Stream<List<RecurringDonation>> onRecurringDonationsChanged() =>
      const Stream.empty();

  @override
  List<RecurringDonation> getRecurringDonations() => const [];

  @override
  bool isLoading() => false;

  @override
  String? getError() => null;

  @override
  Future<void> loadRecurringDonations({String status = 'active'}) async {}
}

void main() {
  const gestureInset = 48.0;
  const viewport = Size(360, 640);

  RecurringDonation donation() {
    return const RecurringDonation(
      id: 'donation-id',
      userId: 'user-id',
      amount: 15,
      frequency: Frequency.monthly,
      numberOfTurns: 0,
      startDate: '2026-10-01T00:00:00.000',
      currentState: RecurringDonationState.active,
      creationDateTime: '2026-09-22T14:09:00.000',
      collectGroupName: 'Test Org',
    );
  }

  RecurringDonationDetailCubit cubit() {
    return RecurringDonationDetailCubit(
      _FakeRecurringDonationDetailRepository(),
      _FakeRecurringDonationsOverviewRepository(),
    );
  }

  testWidgets(
    'Cancel donation stays hittable above a 48px bottom gesture inset',
    (tester) async {
      tester.view.physicalSize = viewport;
      tester.view.devicePixelRatio = 1;
      tester.view.padding = FakeViewPadding.zero;
      tester.view.viewPadding = const FakeViewPadding(bottom: gestureInset);
      addTearDown(tester.view.reset);

      final detailCubit = cubit();
      addTearDown(detailCubit.close);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TextButton(
                  onPressed: () {
                    RecurringDonationDetailManageSheet.show(
                      context,
                      cubit: detailCubit,
                      recurringDonation: donation(),
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      final cancelFinder = find.widgetWithText(FunButton, 'Cancel donation');
      expect(find.widgetWithText(FunButton, 'Edit donation'), findsOneWidget);
      expect(find.widgetWithText(FunButton, 'Pause donation'), findsOneWidget);
      expect(cancelFinder, findsOneWidget);
      expect(cancelFinder.hitTestable(), findsOneWidget);

      final cancelBottom = tester.getRect(cancelFinder).bottom;
      expect(cancelBottom, lessThanOrEqualTo(viewport.height - gestureInset));
    },
  );
}
