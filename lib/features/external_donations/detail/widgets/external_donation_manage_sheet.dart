import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/external_donations/detail/cubit/external_donation_detail_cubit.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_manage_field.dart';
import 'package:givt_app/features/external_donations/detail/widgets/external_donation_manage_list_item.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_display.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/utils/util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExternalDonationManageSheet {
  const ExternalDonationManageSheet._();

  static Future<void> show(
    BuildContext context, {
    required ExternalDonationDetailCubit cubit,
    required ExternalDonationDetailUIModel uiModel,
  }) {
    final locals = context.l10n;
    final auth = context.read<AuthCubit>().state;
    final currency = Util.getCurrencySymbol(countryCode: auth.user.country);
    final country = Country.fromCode(auth.user.country);
    final locale = Util.getLanguageTageFromLocale(context);
    final donation = uiModel.donation;
    final anchorDate = donation.startDateTime ?? DateTime.now();

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return FunBottomSheet(
          title: locals.recurringDonationsDetailManageButton,
          closeAction: () => Navigator.of(sheetContext).pop(),
          content: Column(
            children: [
              ExternalDonationManageListItem(
                icon: FontAwesomeIcons.moneyBillWave,
                label: locals.externalDonationsManageAmount,
                value:
                    '$currency${Util.formatNumberComma(donation.amount, country)}',
                analyticsEvent:
                    AnalyticsEventName.externalDonationsManageAmountClicked
                        .toEvent(),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  cubit.onManageFieldPressed(ExternalDonationManageField.amount);
                },
              ),
              if (donation.isRecurring) ...[
                ExternalDonationManageListItem(
                  icon: FontAwesomeIcons.arrowsRotate,
                  label: locals.externalDonationsManageFrequency,
                  value: ExternalDonationDisplay.formatFrequencyWithDay(
                    locals: locals,
                    frequency: donation.frequency,
                    anchorDate: anchorDate,
                    locale: locale,
                  ),
                  analyticsEvent: AnalyticsEventName
                      .externalDonationsManageFrequencyClicked
                      .toEvent(),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    cubit.onManageFieldPressed(
                      ExternalDonationManageField.frequency,
                    );
                  },
                ),
                ExternalDonationManageListItem(
                  icon: FontAwesomeIcons.solidCalendar,
                  label: locals.externalDonationsManageStartDate,
                  value: ExternalDonationDisplay.formatStartDate(
                    donation,
                    locale,
                  ),
                  analyticsEvent: AnalyticsEventName
                      .externalDonationsManageStartDateClicked
                      .toEvent(),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    cubit.onManageFieldPressed(
                      ExternalDonationManageField.startDate,
                    );
                  },
                ),
              ] else
                ExternalDonationManageListItem(
                  icon: FontAwesomeIcons.solidCalendar,
                  label: locals.externalDonationsDetailOneOffDate,
                  value: ExternalDonationDisplay.formatStartDate(
                    donation,
                    locale,
                  ),
                  analyticsEvent:
                      AnalyticsEventName.externalDonationsManageDateClicked
                          .toEvent(),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    cubit.onManageFieldPressed(ExternalDonationManageField.date);
                  },
                ),
              const SizedBox(height: 24),
              FunButton(
                text: locals.externalDonationsManageDeleteDonation,
                variant: FunButtonVariant.secondary,
                fullBorder: true,
                borderColor: FamilyAppTheme.error40,
                textColor: FamilyAppTheme.error40,
                analyticsEvent:
                    AnalyticsEventName.externalDonationsManageDeleteClicked
                        .toEvent(),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  cubit.onDeleteDonationPressed();
                },
              ),
              if (donation.isRecurring) ...[
                const SizedBox(height: 12),
                FunButton(
                  text: locals.externalDonationsManageEditSpecificRecords,
                  variant: FunButtonVariant.secondary,
                  fullBorder: true,
                  analyticsEvent: AnalyticsEventName
                      .externalDonationsManageEditRecordsClicked
                      .toEvent(),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    cubit.onEditSpecificRecordsPressed();
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
