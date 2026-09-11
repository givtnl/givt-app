import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/donation_overview/models/donation_group.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';
import 'package:givt_app/features/donation_overview/models/donation_status.dart';
import 'package:givt_app/features/donation_overview/pages/donation_detail_page.dart';
import 'package:givt_app/features/donation_overview/pages/external_donation_history_detail_page.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
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

    final sortedDonations = List<DonationItem>.from(donationGroup.donations)
      ..sort((a, b) {
        if (donationGroup.isExternal) {
          return 0;
        }
        final aId = a.collectId ?? 1;
        final bId = b.collectId ?? 1;
        return aId.compareTo(bId);
      });

    final firstDonation = sortedDonations.first;

    Widget content = Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: FamilyAppTheme.neutralVariant95,
            ),
          ),
        ),
        child: Row(
          children: [
            donationGroup.isExternal
                ? _buildExternalIndicator(context)
                : _buildStatusIndicator(firstDonation.status),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: LabelMediumText(
                          donationGroup.organisationName,
                        ),
                      ),
                      if (!donationGroup.isExternal &&
                          donationGroup.isGiftAidEnabled) ...[
                        const SizedBox(width: 4),
                        Image.asset(
                          'assets/images/gift_aid_yellow.png',
                          height: 20,
                        ),
                      ],
                      if (!donationGroup.isExternal &&
                          donationGroup.isOnlineGiving) ...[
                        const SizedBox(width: 4),
                        const FaIcon(
                          FontAwesomeIcons.globe,
                          size: 16,
                          color: FamilyAppTheme.primary20,
                        ),
                      ],
                      if (donationGroup.isRecurringDonation) ...[
                        const SizedBox(width: 4),
                        FaIcon(
                          FontAwesomeIcons.repeat,
                          size: 12,
                          color: donationGroup.isExternal
                              ? FunTheme.of(context).tertiary20
                              : FamilyAppTheme.primary20,
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
                            if (donationGroup.isExternal)
                              BodySmallText(
                                context.l10n.donationHistoryExternalListSubtitle,
                                color: FamilyAppTheme.neutralVariant40,
                              )
                            else
                              ...sortedDonations.map(
                                (donation) => Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: BodySmallText(
                                    donation.allocationDisplayLabel(
                                      context.l10n,
                                    ),
                                    color: FamilyAppTheme.neutralVariant40,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            if (!donationGroup.isExternal &&
                                donationGroup.platformFeeAmount > 0)
                              BodySmallText(
                                context
                                    .l10n
                                    .donationOverviewPlatformContribution,
                                color: FamilyAppTheme.neutralVariant40,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (donationGroup.timeStamp != null)
                              LabelSmallText(
                                Util.formatDateAtTimeLocal(
                                  donationGroup.timeStamp!,
                                  Platform.localeName,
                                ),
                                color: FamilyAppTheme.neutralVariant50,
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ...sortedDonations.map(
                            (donation) => LabelMediumText(
                              '$currencySymbol ${Util.formatNumberComma(
                                donation.amount,
                                Country.fromCode(country),
                              )}',
                              color: donationGroup.isExternal
                                  ? FamilyAppTheme.neutralVariant20
                                  : donation.status.textColor,
                            ),
                          ),
                          if (!donationGroup.isExternal &&
                              donationGroup.platformFeeAmount > 0)
                            LabelMediumText(
                              '$currencySymbol ${Util.formatNumberComma(
                                donationGroup.platformFeeAmount,
                                Country.fromCode(country),
                              )}',
                              color: sortedDonations.first.status.textColor,
                            ),
                          if (!donationGroup.isExternal)
                            BodySmallText(
                              _getStatusText(
                                context,
                                firstDonation.status.type,
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
      ),
    );

    return GestureDetector(
      onTap: () {
        if (analyticsEvent != null) {
          AnalyticsHelper.logEvent(
            eventName: analyticsEvent!.name,
            eventProperties: analyticsEvent!.parameters,
          );
        }

        if (donationGroup.isExternal) {
          AnalyticsHelper.logEvent(
            eventName: AnalyticsEventName.donationHistoryExternalRowClicked,
          );
          Navigator.push(
            context,
            ExternalDonationHistoryDetailPage(
              donation: firstDonation,
            ).toRoute(context),
          );
          return;
        }

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

  Widget _buildExternalIndicator(BuildContext context) {
    final theme = FunTheme.of(context);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: theme.tertiary98,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.arrowUpRightFromSquare,
          color: theme.tertiary40,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(DonationStatus status) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: status.backgroundColor,
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
