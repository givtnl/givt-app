import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/donation_overview/models/donation_group.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';
import 'package:givt_app/features/donation_overview/models/donation_status.dart';
import 'package:givt_app/features/donation_overview/repositories/donation_overview_repository.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/about_givt_bottom_sheet.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DonationDetailPage extends StatelessWidget {
  const DonationDetailPage({
    required this.donationGroup,
    super.key,
  });

  final DonationGroup donationGroup;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;
    final country = user.country;
    final currencySymbol = Util.getCurrencySymbol(countryCode: country);

    // Get the first donation for status and other details
    final firstDonation = donationGroup.donations.first;
    final status = firstDonation.status;

    // Sort donations by collect ID (1, 2, 3)
    final sortedDonations = List<DonationItem>.from(donationGroup.donations)
      ..sort((a, b) {
        final aId = a.collectId ?? 1;
        final bId = b.collectId ?? 1;
        return aId.compareTo(bId);
      });

    return FunScaffold(
      appBar: FunTopAppBar.white(
        leading: GivtBackButtonFlat(
          onPressed: () async {
            context.pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () => _showContactForm(
              context,
              firstDonation.id.toString(),
              _getStatusText(context, status.type),
            ),
            icon: const FaIcon(FontAwesomeIcons.circleQuestion),
          ),
        ],
      ),
      body: Column(
        children: [
          // Status indicator
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: status.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                status.icon,
                color: status.iconColor,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Organization name
          TitleMediumText(
            donationGroup.organisationName,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Status text
          BodySmallText(
            _getStatusText(context, status.type),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Transaction details
          Column(
            children: [
              // Collection amounts
              ...sortedDonations.map((donation) {
                return _buildDetailRow(
                  label: '${context.l10n.collect} ${donation.collectId ?? 1}',
                  value:
                      '$currencySymbol ${Util.formatNumberComma(
                        donation.amount,
                        Country.fromCode(country),
                      )}',
                  showDivider: true,
                );
              }),

              // Platform fee if exists
              if (donationGroup.platformFeeAmount > 0)
                _buildDetailRow(
                  label: locals.donationOverviewPlatformContribution,
                  value:
                      '$currencySymbol ${Util.formatNumberComma(
                        donationGroup.platformFeeAmount,
                        Country.fromCode(country),
                      )}',
                  showDivider: true,
                ),

              // Date
              if (donationGroup.timeStamp != null)
                _buildDetailRow(
                  label: context.l10n.date,
                  value:
                      '${DateFormat.yMMMMd(
                        Platform.localeName,
                      ).format(donationGroup.timeStamp!)} ${context.l10n.donationOverviewDateAt} ${DateFormat.Hm(
                        Platform.localeName,
                      ).format(donationGroup.timeStamp!)}',
                  showDivider: true,
                ),

              // Transaction ID
              _buildDetailRow(
                label: 'Transaction ID',
                value: '#${firstDonation.id}',
                showDivider: false,
              ),
            ],
          ),

          const Spacer(),

          // Action button based on status
          _buildActionButton(
            context,
            status,
            donationGroup,
            Country.fromCode(country),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BodySmallText.primary30(
                label,
              ),
              Expanded(
                child: LabelMediumText.primary40(
                  value,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            color: FamilyAppTheme.neutralVariant95,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    DonationStatus status,
    DonationGroup donationGroup,
    Country country,
  ) {
    switch (status.type) {
      case DonationStatusType.completed:
        return FunButton.secondary(
          onTap: () => _handleRefund(context, donationGroup, country),
          text: context.l10n.requestRefund,
          analyticsEvent: AmplitudeEvents.donationDetailRefundClicked.toEvent(
            parameters: {
              'donation': donationGroup.toJson()
            }
          ),
        );

      case DonationStatusType.created:
        return FunButton.destructiveSecondary(
          onTap: () => _handleCancel(context, donationGroup),
          text: context.l10n.cancel,
          analyticsEvent: AmplitudeEvents.donationDetailCancelClicked.toEvent(
            parameters: {
              'donation': donationGroup.toJson()
            }
          ),
        );

      case DonationStatusType.inProcess:
        return const SizedBox.shrink();

      case DonationStatusType.refused:
        return FunButton(
          onTap: () => _handleRetry(context, donationGroup),
          text: context.l10n.tryAgain,
          analyticsEvent: AmplitudeEvents.donationDetailRetryClicked.toEvent(
            parameters: {
              'donation': donationGroup.toJson()
            }
          ),
        );

      case DonationStatusType.cancelled:
        return FunButton(
          onTap: () => _handleRetry(context, donationGroup),
          text: context.l10n.tryAgain,
          analyticsEvent: AmplitudeEvents.donationDetailRetryClicked.toEvent(
            parameters: {
              'donation': donationGroup.toJson()
            }
          ),
        );
    }
  }

  void _showContactForm(
    BuildContext context,
    String transactionId,
    String status,
  ) {
    AboutGivtBottomSheet.show(
      context,
      initialMessage: context.l10n.donationOverviewContactMessage(
        status,
        transactionId,
      ).replaceAll(r'\n', '\n'),
    );
  }

  Future<void> _handleRefund(
    BuildContext context,
    DonationGroup donationGroup,
    Country country,
  ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => WarningDialog(
        title: context.l10n.refundTitle,
        content: country.isBACS
            ? context.l10n.refundMessageBACS
            : context.l10n.refundMessageGeneral,
        onConfirm: () => context.pop(),
      ),
    );
  }

  Future<void> _handleCancel(
    BuildContext context,
    DonationGroup donationGroup,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog(
        title: context.l10n.cancelGiftAlertTitle,
        content: context.l10n.cancelGiftAlertMessage,
        onConfirm: () => context.pop(true),
        onCancel: () => context.pop(false),
        confirmText: context.l10n.yes,
        cancelText: context.l10n.no,
      ),
    );

    if (confirmed ?? false) {
      unawaited(AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.onConfirmCancelDonation,
        eventProperties: donationGroup.toJson(),
      ));

      try {
        // Extract transaction IDs from the donation group
        final transactionIds = donationGroup.donations
            .map((d) => d.id)
            .toList();
        // Delete the donations using the repository
        final repository = getIt<DonationOverviewRepository>();
        final success = await repository.deleteDonation(transactionIds);

        if (success) {
          // Navigate back to previous page
          context.pop();

          // Reload donations in the overview page
          // The overview page will automatically refresh due to the repository stream
        } else {
          // Show error message if deletion failed
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.somethingWentWrong),
              ),
            );
          }
        }
      } catch (e) {
        // Show error message if deletion failed
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.somethingWentWrong),
            ),
          );
        }
      }
    } else {
      // Log when user clicks "No" on the confirmation dialog
      await AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.cancelDonationNoClicked,
        eventProperties: donationGroup.toJson(),
      );
    }
  }

  void _handleRetry(BuildContext context, DonationGroup donationGroup) {
    // TODO: Implement retry functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Retry functionality will be implemented later'),
      ),
    );
  }

  String _getStatusText(BuildContext context, DonationStatusType type) {
    switch (type) {
      case DonationStatusType.created:
        return context.l10n.donationOverviewStatusInProcessFull;
      case DonationStatusType.inProcess:
        return context.l10n.donationOverviewStatusInProcessFull;
      case DonationStatusType.completed:
        return context.l10n.donationOverviewStatusProcessedFull;
      case DonationStatusType.refused:
        return context.l10n.donationOverviewStatusRefusedFull;
      case DonationStatusType.cancelled:
        return context.l10n.donationOverviewStatusCancelledFull;
    }
  }
}
