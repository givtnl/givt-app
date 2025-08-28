import 'dart:async';
import 'dart:convert';
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
import 'package:givt_app/features/family/shared/widgets/content/tutorial/fun_tooltip.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/about_givt_bottom_sheet.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

class DonationDetailPage extends StatefulWidget {
  const DonationDetailPage({
    required this.donationGroup,
    super.key,
  });

  final DonationGroup donationGroup;

  @override
  State<DonationDetailPage> createState() => _DonationDetailPageState();
}

class _DonationDetailPageState extends State<DonationDetailPage> {
  late final TooltipController _tooltipController;

  @override
  void initState() {
    super.initState();
    _tooltipController = TooltipController();
  }

  @override
  void dispose() {
    _tooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;
    final country = user.country;
    final currencySymbol = Util.getCurrencySymbol(countryCode: country);

    // Get the first donation for status and other details
    final firstDonation = widget.donationGroup.donations.first;
    final status = firstDonation.status;

    // Sort donations by collect ID (1, 2, 3)
    final sortedDonations =
        List<DonationItem>.from(widget.donationGroup.donations)..sort((a, b) {
          final aId = a.collectId ?? 1;
          final bId = b.collectId ?? 1;
          return aId.compareTo(bId);
        });

    return OverlayTooltipScaffold(
      controller: _tooltipController,
      overlayColor: Colors.transparent,
      builder: (context) => FunScaffold(
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
              widget.donationGroup.organisationName,
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
                if (widget.donationGroup.platformFeeAmount > 0)
                  _buildPlatformFeeRow(
                    context,
                    locals,
                    currencySymbol,
                    country,
                  ),

                // Date
                if (widget.donationGroup.timeStamp != null)
                  _buildDetailRow(
                    label: context.l10n.date,
                    value:
                        '${DateFormat.yMMMMd(
                          Platform.localeName,
                        ).format(widget.donationGroup.timeStamp!)} ${context.l10n.donationOverviewDateAt} ${DateFormat.Hm(
                          Platform.localeName,
                        ).format(widget.donationGroup.timeStamp!)}',
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
              widget.donationGroup,
              Country.fromCode(country),
            ),
          ],
        ),
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

  Widget _buildPlatformFeeRow(
    BuildContext context,
    AppLocalizations locals,
    String currencySymbol,
    String country,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FunTooltip(
                tooltipIndex: widget.donationGroup.donations.first.id,
                title: context.l10n.donationOverviewPlatformContributionTitle,
                description:
                    context.l10n.donationOverviewPlatformContributionText,
                labelBottomLeft: '',
                showImage: false,
                showButton: false,
                dropShadow: true,
                enableTapToDismiss: true,
                onButtonTap: () => _tooltipController.dismiss(),
                onHighlightedWidgetTap: () => _tooltipController.dismiss(),
                tooltipVerticalPosition: TooltipVerticalPosition.BOTTOM,
                child: GestureDetector(
                  onTap: () async {
                    await AnalyticsHelper.logEvent(
                      eventName: AmplitudeEvents
                          .donationOverviewPlatformContributionClicked,
                      eventProperties: {
                        'donation': widget.donationGroup.toJson(),
                      },
                    );
                    _tooltipController.start(
                      widget.donationGroup.donations.first.id,
                    );

                    // auto close after 5000 ms
                    Future.delayed(
                      const Duration(milliseconds: 5000),
                      () {
                        _tooltipController.pause();
                      },
                    );
                  },
                  child: Theme(
                    data: const FamilyAppTheme().toThemeData(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BodySmallText.primary30(
                          locals.donationOverviewPlatformContribution,
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: FamilyAppTheme.neutralVariant40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: LabelMediumText.primary40(
                  '$currencySymbol ${Util.formatNumberComma(
                    widget.donationGroup.platformFeeAmount,
                    Country.fromCode(country),
                  )}',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
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
            parameters: {'donation': donationGroup.toJson()},
          ),
        );

      case DonationStatusType.created:
        return FunButton.destructiveSecondary(
          onTap: () => _handleCancel(context, donationGroup),
          text: context.l10n.cancel,
          analyticsEvent: AmplitudeEvents.donationDetailCancelClicked.toEvent(
            parameters: {'donation': donationGroup.toJson()},
          ),
        );

      case DonationStatusType.inProcess:
        return const SizedBox.shrink();

      case DonationStatusType.refused:
        return FunButton(
          onTap: () => _handleRetry(context, donationGroup),
          text: context.l10n.tryAgain,
          analyticsEvent: AmplitudeEvents.donationDetailRetryClicked.toEvent(
            parameters: {'donation': donationGroup.toJson()},
          ),
        );

      case DonationStatusType.cancelled:
        return FunButton(
          onTap: () => _handleRetry(context, donationGroup),
          text: context.l10n.tryAgain,
          analyticsEvent: AmplitudeEvents.donationDetailRetryClicked.toEvent(
            parameters: {'donation': donationGroup.toJson()},
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
      initialMessage: context.l10n
          .donationOverviewContactMessage(
            status,
            transactionId,
          )
          .replaceAll(r'\n', '\n'),
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
      unawaited(
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.onConfirmCancelDonation,
          eventProperties: donationGroup.toJson(),
        ),
      );

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
    // Get the first donation for amount and organization details
    final firstDonation = donationGroup.donations.first;

    // Log analytics event for retry
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.donationDetailRetryClicked,
        eventProperties: donationGroup.toJson(),
      ),
    );

    // Navigate back to homescreen with prefilled amount and organization
    // Encode mediumId to base64 as expected by the app router
    context.goNamed(
      Pages.home.name,
      queryParameters: {
        'amount': firstDonation.amount.toString(),
        'code': base64Encode(utf8.encode(firstDonation.mediumId)),
        'retry': 'true',
      },
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
