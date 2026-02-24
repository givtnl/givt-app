import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/recurring_donations/detail/cubit/recurring_donation_detail_cubit.dart';
import 'package:givt_app/features/recurring_donations/detail/pages/recurring_donation_detail_page.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/l10n/l10n.dart';

void main() {
  group('RecurringDonationDetailPage end date label', () {
    testWidgets(
      'shows Ends label when donation is active',
      (tester) async {
        final uiModel = RecurringDonationDetailUIModel(
          organizationName: 'Test org',
          organizationIcon: '',
          organisationType: CollectGroupType.church,
          totalDonated: 10,
          remainingTime: '',
          endDate: DateTime.now().add(const Duration(days: 10)),
          progress: null,
          history: const [],
          isLoading: false,
          isActive: true,
        );

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                return RecurringDonationDetailPage(
                  recurringDonation: RecurringDonation(
                    id: '1',
                    organizationName: uiModel.organizationName,
                    amountPerTurn: 10,
                    frequency: Frequency.monthly,
                    currentState: RecurringDonationState.active,
                  ),
                );
              },
            ),
          ),
        );

        expect(find.textContaining('Ends '), findsOneWidget);
      },
    );

    testWidgets(
      'shows Ended label when donation is not active',
      (tester) async {
        final uiModel = RecurringDonationDetailUIModel(
          organizationName: 'Test org',
          organizationIcon: '',
          organisationType: CollectGroupType.church,
          totalDonated: 10,
          remainingTime: '',
          endDate: DateTime.now().subtract(const Duration(days: 10)),
          progress: null,
          history: const [],
          isLoading: false,
          isActive: false,
        );

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                return RecurringDonationDetailPage(
                  recurringDonation: RecurringDonation(
                    id: '1',
                    organizationName: uiModel.organizationName,
                    amountPerTurn: 10,
                    frequency: Frequency.monthly,
                    currentState: RecurringDonationState.completed,
                  ),
                );
              },
            ),
          ),
        );

        expect(find.textContaining('Ended '), findsOneWidget);
      },
    );
  });
}

