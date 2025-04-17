import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/overview/models/givt_group.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class GivtListItem extends StatelessWidget {
  const GivtListItem({
    required this.givtGroup,
    required this.onCancel,
    super.key,
  });

  final GivtGroup givtGroup;
  final void Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final userCountry = context.read<AuthCubit>().state.user.country;
    final country = Country.fromCode(userCountry);
    final currency = NumberFormat.simpleCurrency(
      name: country.currency,
    );

    // Check if donation was made within the last month
    final now = DateTime.now();
    final oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
    final isWithinLastMonth = givtGroup.timeStamp != null &&
        givtGroup.timeStamp!.isAfter(oneMonthAgo);

    // Determine if any button should be shown
    final showCancelButton = givtGroup.status == 1;
    final showRefundButton = givtGroup.status == 3 && isWithinLastMonth;

    // Check if this is an online giving donation (type 7)
    final isOnlineGiving = givtGroup.status == 7;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Util.getStatusColor(givtGroup.status),
            width: 10,
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppTheme.givtLightGray,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 5,
                            color: AppTheme.givtLightPurple,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          DateFormat('dd')
                              .format(givtGroup.timeStamp!.toLocal()),
                          style: textTheme.titleLarge!.copyWith(
                            color: AppTheme.givtBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat('HH:mm').format(givtGroup.timeStamp!.toLocal()),
                    style: textTheme.bodySmall!.copyWith(
                      color: AppTheme.givtBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Visibility(
                                visible: givtGroup.isGiftAidEnabled,
                                child: Image.asset(
                                  'assets/images/gift_aid_yellow.png',
                                  height: 20,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  givtGroup.organisationName,
                                  style: textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (isOnlineGiving)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Online Giving',
                                    style: textTheme.bodySmall!.copyWith(
                                      color: AppTheme.givtBlue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      ...givtGroup.givts.map(
                        (collection) => Row(
                          children: [
                            Text(
                              '${context.l10n.collect} ${collection.collectId}',
                              textAlign: TextAlign.start,
                            ),
                            Expanded(child: Container()),
                            Text(
                              '${currency.currencySymbol} ${Util.formatNumberComma(
                                collection.amount,
                                country,
                              )}',
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // .. More buttons :)
              const SizedBox(width: 4),
              if (showCancelButton)
                _cancelButton(context, textTheme)
              else if (showRefundButton)
                _refundButton(context, country, textTheme),
            ],
          ),
        ],
      ),
    );
  }

  ElevatedButton _refundButton(
      BuildContext context, Country country, TextTheme textTheme) {
    return ElevatedButton(
      onPressed: () async {
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
        await AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.refundInfoRequested,
          eventProperties: givtGroup.toJson(),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.givtBlue,
        foregroundColor: Colors.white,
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Text(
        context.l10n.requestRefund,
        style: textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  ElevatedButton _cancelButton(BuildContext context, TextTheme textTheme) {
    return ElevatedButton(
      onPressed: () async {
        // Log when the cancel button is initially pressed
        await AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.cancelDonationButtonClicked,
          eventProperties: givtGroup.toJson(),
        );

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
          await AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.onConfirmCancelDonation,
            eventProperties: givtGroup.toJson(),
          );
          onCancel?.call();
        } else {
          // Log when user clicks "No" on the confirmation dialog
          await AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.cancelDonationNoClicked,
            eventProperties: givtGroup.toJson(),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.givtRed,
        foregroundColor: Colors.white,
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Text(
        context.l10n.cancel,
        style: textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
