import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_draft.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_flow_step.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_ui_model.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_schedule.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';
import 'package:givt_app/l10n/arb/app_localizations_en.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  final en = AppLocalizationsEn();

  ExternalDonationCreateUIModel buildModel(ExternalDonationCreateDraft draft) {
    return ExternalDonationCreateUIModel(draft: draft);
  }

  group('ExternalDonationCreateUIModel previewRowsForStep', () {
    test('returns empty preview on organisation step', () {
      const model = ExternalDonationCreateUIModel(
        draft: ExternalDonationCreateDraft(organisationName: 'World Vision'),
      );

      expect(
        model.previewRowsForStep(
          ExternalDonationCreateFlowStep.organisation,
          currencySymbol: '€',
          formatAmount: (a) => a.toStringAsFixed(2),
          locals: en,
          locale: 'en',
        ),
        isEmpty,
      );
    });

    test('donation type step returns summary row when org is set', () {
      const model = ExternalDonationCreateUIModel(
        draft: ExternalDonationCreateDraft(
          organisationName: 'World Vision',
          amountInput: '10',
          isOneOff: true,
        ),
      );

      final rows = model.previewRowsForStep(
        ExternalDonationCreateFlowStep.donationType,
        currencySymbol: '€',
        formatAmount: (a) => a.toStringAsFixed(2),
        locals: en,
        locale: 'en',
      );

      expect(rows, hasLength(1));
      expect(rows.first.organisationName, 'World Vision');
      expect(rows.first.typeTagLabel, en.externalDonationsCreatePreviewTypeTag);
      expect(rows.first.primarySubtitle, en.externalDonationsCreateFrequencyOneOff);
      expect(rows.first.amountLabel, '€10.00');
      expect(rows.first.isCompleted, isFalse);
      expect(rows.first.secondarySubtitle, isNull);
    });

    test('one-off date step shows date on third line without completed', () {
      final model = ExternalDonationCreateUIModel(
        draft: ExternalDonationCreateDraft(
          organisationName: 'World Vision',
          amountInput: '15',
          isOneOff: true,
          dateMade: DateTime(2024, 3, 10),
        ),
      );

      final rows = model.previewRowsForStep(
        ExternalDonationCreateFlowStep.oneOffDate,
        currencySymbol: '€',
        formatAmount: (a) => a.toStringAsFixed(2),
        locals: en,
        locale: 'en',
      );

      expect(rows, hasLength(1));
      expect(rows.first.dateLabel, '10 Mar 2024');
      expect(rows.first.isCompleted, isFalse);
    });

    test('stepCount is 3 for one-off and recurring', () {
      expect(
        buildModel(
          const ExternalDonationCreateDraft(isOneOff: true),
        ).stepCount,
        3,
      );
      expect(
        buildModel(
          const ExternalDonationCreateDraft(
            isOneOff: false,
            frequency: ExternalDonationFrequency.monthly,
          ),
        ).stepCount,
        3,
      );
    });

    test('series start step shows preview when start date is set', () {
      final model = ExternalDonationCreateUIModel(
        draft: ExternalDonationCreateDraft(
          organisationName: 'Arango Test',
          amountInput: '24',
          isOneOff: false,
          frequency: ExternalDonationFrequency.monthly,
          seriesStartDate: DateTime(2026, 3, 4),
        ),
      );

      final preview = generateOccurrencePreview(
        seriesStartDate: DateTime(2026, 3, 4),
        frequency: ExternalDonationFrequency.monthly,
        now: DateTime(2026, 5, 30),
      );
      expect(preview.length, greaterThan(2));

      final rows = model.previewRowsForStep(
        ExternalDonationCreateFlowStep.seriesStartDate,
        currencySymbol: '€',
        formatAmount: (a) => a.toStringAsFixed(2),
        locals: en,
        locale: 'en',
      );

      expect(rows.length, lessThanOrEqualTo(3));
      expect(rows.first.isUpcoming, isTrue);
      expect(rows.any((row) => row.isCompleted), isTrue);
      if (DateTime.now().isAfter(DateTime(2026, 4, 4))) {
        expect(rows.length, 3);
        expect(model.previewMoreRecordsLabel(en, 'en'), isNotNull);
      }
    });

    test('visible preview lists upcoming occurrence before past ones', () {
      final model = ExternalDonationCreateUIModel(
        draft: ExternalDonationCreateDraft(
          organisationName: 'Colorful Church',
          amountInput: '87',
          isOneOff: false,
          frequency: ExternalDonationFrequency.monthly,
          seriesStartDate: DateTime(2024, 1, 12),
        ),
      );

      final visible = model.visiblePreview;
      expect(visible, isNotEmpty);

      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final firstDay = DateTime(
        visible.first.year,
        visible.first.month,
        visible.first.day,
      );
      expect(firstDay.isAfter(todayDate), isTrue);

      final rows = model.previewRowsForStep(
        ExternalDonationCreateFlowStep.seriesStartDate,
        currencySymbol: '€',
        formatAmount: (a) => a.toStringAsFixed(2),
        locals: en,
        locale: 'en',
      );

      expect(rows.first.isUpcoming, isTrue);
      expect(rows.any((row) => row.isCompleted), isTrue);
    });

    test('series start preview shows three rows with faded oldest past', () {
      final model = ExternalDonationCreateUIModel(
        draft: ExternalDonationCreateDraft(
          organisationName: 'Colorful Church',
          amountInput: '87',
          isOneOff: false,
          frequency: ExternalDonationFrequency.monthly,
          seriesStartDate: DateTime(2020, 1, 1),
        ),
      );

      final rows = model.previewRowsForStep(
        ExternalDonationCreateFlowStep.seriesStartDate,
        currencySymbol: '€',
        formatAmount: (a) => a.toStringAsFixed(2),
        locals: en,
        locale: 'en',
      );

      expect(rows.length, 3);
      expect(rows.first.isUpcoming, isTrue);
      expect(rows[1].isCompleted, isTrue);
      expect(rows[2].isFaded, isTrue);
      expect(model.hiddenPastPreviewCount, greaterThan(0));
      expect(model.previewMoreRecordsLabel(en, 'en'), isNotNull);
    });

    test('series start step caps preview rows and reports hidden count', () {
      final model = ExternalDonationCreateUIModel(
        draft: ExternalDonationCreateDraft(
          organisationName: 'World Vision',
          amountInput: '25',
          isOneOff: false,
          frequency: ExternalDonationFrequency.monthly,
          seriesStartDate: DateTime(2024, 1, 15),
        ),
        previewVisibleCount: 3,
      );

      final rows = model.previewRowsForStep(
        ExternalDonationCreateFlowStep.seriesStartDate,
        currencySymbol: '€',
        formatAmount: (a) => a.toStringAsFixed(0),
        locals: en,
        locale: 'en',
      );

      expect(rows.length, lessThanOrEqualTo(3));
      expect(model.hiddenPastPreviewCount, greaterThanOrEqualTo(0));
      if (model.hiddenPastPreviewCount > 0) {
        expect(
          model.previewMoreRecordsLabel(en, 'en'),
          isNotNull,
        );
      }
    });
  });

  group('ExternalDonationCreateDraft validation', () {
    test('isDonationTypeStepValid requires amount and type', () {
      const incomplete = ExternalDonationCreateDraft(
        amountInput: '10',
      );
      expect(incomplete.isDonationTypeStepValid, isFalse);

      const oneOff = ExternalDonationCreateDraft(
        amountInput: '10',
        isOneOff: true,
      );
      expect(oneOff.isDonationTypeStepValid, isTrue);

      const recurring = ExternalDonationCreateDraft(
        amountInput: '10',
        isOneOff: false,
        frequency: ExternalDonationFrequency.monthly,
      );
      expect(recurring.isDonationTypeStepValid, isTrue);
    });
  });
}
