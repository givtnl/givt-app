import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/donation_overview/models/donation_group.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';
import 'package:givt_app/features/donation_overview/models/donation_status.dart';
import 'package:givt_app/features/donation_overview/pages/donation_detail_page.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/fun_theme_legacy.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/util.dart';

class DonationListItem extends StatelessWidget {
  const DonationListItem({
    required this.donationGroup,
    this.analyticsEvent,
    super.key,
  });

  final DonationGroup donationGroup;
  final AnalyticsEvent? analyticsEvent;

  @override
  Widget build(BuildContext context) {
    final country = context.read<AuthCubit>().state.user.country;
    final currencySymbol = Util.getCurrencySymbol(
      countryCode: country,
    );

    // Sort donations by collect ID (1, 2, 3)
    final sortedDonations = List<DonationItem>.from(donationGroup.donations)
      ..sort((a, b) {
        final aId = a.collectId ?? 1;
        final bId = b.collectId ?? 1;
        return aId.compareTo(bId);
      });

    Widget content = Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: FamilyAppTheme.neutralVariant95, // Light grey border
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Status indicator (colored circle with icon) - matches Figma design
                _buildStatusIndicator(donationGroup.donations.first.status),

                const SizedBox(width: 16),

                // Main content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Organization name - dark green text
                          Expanded(
                            child: LabelMediumText(
                              donationGroup.organisationName,
                            ),
                          ),

                          if (donationGroup.isGiftAidEnabled) ...[
                            const SizedBox(width: 4),
                            Image.asset(
                              'assets/images/gift_aid_yellow.png',
                              height: 20,
                            ),
                          ],
                          if (donationGroup.isOnlineGiving) ...[
                            const SizedBox(width: 4),
                            const FaIcon(
                              FontAwesomeIcons.globe,
                              size: 16,
                              color: FamilyAppTheme.primary20,
                            ),
                          ],
                          if (donationGroup.isRecurringDonation) ...[
                            const SizedBox(width: 4),
                            const FaIcon(
                              FontAwesomeIcons.repeat,
                              size: 12,
                              color: FamilyAppTheme.primary20,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Collection details - show all collect IDs
                                ...sortedDonations.map(
                                  (donation) => Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: Row(
                                      children: [
                                        BodySmallText(
                                          '${context.l10n.collect} ${donation.collectId ?? 1}',
                                          color:
                                              FamilyAppTheme.neutralVariant40,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Platform contribution if exists
                                if (donationGroup.platformFeeAmount > 0)
                                  BodySmallText(
                                    context
                                        .l10n
                                        .donationOverviewPlatformContribution,
                                    color: FamilyAppTheme.neutralVariant40,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                // Date - grey text
                                if (donationGroup.timeStamp != null)
                                  LabelSmallText(
                                    Util.formatDateAtTimeLocal(
                                      donationGroup.timeStamp!,
                                      Platform.localeName,
                                    ),
                                    color: FamilyAppTheme
                                        .neutralVariant50, // Grey text
                                  ),
                              ],
                            ),
                          ),

                          // Right side - total amount and status
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ...sortedDonations.map(
                                (donation) => LabelMediumText(
                                  '$currencySymbol ${Util.formatNumberComma(
                                    donation.amount,
                                    Country.fromCode(country),
                                  )}',
                                  color: donation.status.textColor,
                                ),
                              ),
                              if (donationGroup.platformFeeAmount > 0)
                                LabelMediumText(
                                  '$currencySymbol ${Util.formatNumberComma(
                                    donationGroup.platformFeeAmount,
                                    Country.fromCode(country),
                                  )}',
                                  color: sortedDonations.first.status.textColor,
                                ),
                              // Status text - colored based on status
                              BodySmallText(
                                _getStatusText(
                                  context,
                                  donationGroup.donations.first.status.type,
                                ),
                                color: FamilyAppTheme.neutralVariant50,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // Wrap with GestureDetector for analytics and tap handling
    if (analyticsEvent != null) {
      content = GestureDetector(
        onTap: () {
          // Log analytics event
          AnalyticsHelper.logEvent(
            eventName: analyticsEvent!.name,
          );
          // Navigate to detail page
          Navigator.push(
            context,
            DonationDetailPage(
              donationGroup: donationGroup,
            ).toRoute(context),
          );
        },
        child: content,
      );
    } else {
      content = GestureDetector(
        onTap: () {
          // Navigate to detail page
          Navigator.push(
            context,
            DonationDetailPage(
              donationGroup: donationGroup,
            ).toRoute(context),
          );
        },
        child: content,
      );
    }

    return content;
  }

  Widget _buildStatusIndicator(DonationStatus status) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: status.backgroundColor, // Light background with status color
        shape: BoxShape.circle,
      ),
      child: Center(
        child: FaIcon(
          status.icon,
          color: status.iconColor,
          size: 20,
        ),
      ),
    );
  }

  String _getStatusText(BuildContext context, DonationStatusType type) {
    switch (type) {
      case DonationStatusType.created:
        return context.l10n.donationOverviewStatusInProcess;
      case DonationStatusType.inProcess:
        return context.l10n.donationOverviewStatusInProcess;
      case DonationStatusType.completed:
        return '';
      case DonationStatusType.refused:
        return context.l10n.donationOverviewStatusRefused;
      case DonationStatusType.cancelled:
        return context.l10n.donationOverviewStatusCancelled;
    }
  }
}
