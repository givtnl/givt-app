import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/family_history/family_history_cubit/family_history_cubit.dart';
import 'package:givt_app/features/family/features/family_history/models/donation.dart';
import 'package:givt_app/features/family/features/family_history/models/donation_helper.dart';
import 'package:givt_app/features/family/features/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/family/features/parental_approval/dialogs/parental_approval_dialog.dart';
import 'package:givt_app/features/impact_groups_legacy_logic/cubit/impact_groups_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/string_datetime_extension.dart';
import 'package:givt_app/utils/utils.dart';

class PendingDonationWidget extends StatefulWidget {
  const PendingDonationWidget({
    required this.donation,
    super.key,
  });

  final Donation donation;

  @override
  State<PendingDonationWidget> createState() => _PendingDonationWidgetState();
}

class _PendingDonationWidgetState extends State<PendingDonationWidget> {
  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.sizeOf(context);

    return InkWell(
      onTap: () async {
        await AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.pendingDonationClicked,
          eventProperties: {
            'child_name': widget.donation.name,
            'charity_name': widget.donation.organizationName,
            'date': widget.donation.date,
            'amount': widget.donation.amount,
          },
        );

        if (!context.mounted) return;

        final familyHystoryCubit = context.read<FamilyHistoryCubit>();
        final familyOverviewCubit = context.read<FamilyOverviewCubit>();
        final impactGroupsCubit = context.read<ImpactGroupsCubit>();

        await showDialog<void>(
          barrierDismissible: false,
          context: context,
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: familyHystoryCubit,
              ),
              BlocProvider.value(
                value: familyOverviewCubit,
              ),
              BlocProvider.value(
                value: impactGroupsCubit,
              ),
            ],
            child: Theme(
              data: AppTheme.lightTheme,
              child: ParentalApprovalDialog(
                donation: widget.donation,
              ),
            ),
          ),
        );
      },
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      splashColor: AppTheme.childHistoryPendingLight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: DottedBorder(
          borderType: BorderType.RRect,
          dashPattern: const [4, 4],
          radius: const Radius.circular(20),
          strokeWidth: 2,
          color: AppTheme.childHistoryPendingLight,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.childHistoryPendingLight.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${widget.donation.amount.toStringAsFixed(2)} ${locals.childHistoryBy} ${widget.donation.name}',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: DonationState.getAmountColor(
                                    widget.donation.state,
                                  ),
                                ),
                      ),
                      SizedBox(
                        width: widget.donation.medium == DonationMediumType.nfc
                            ? size.width * 0.55
                            : size.width * 0.75,
                        child: Text(
                          '${widget.donation.isToGoal ? context.l10n.familyGoalPrefix : ''}'
                          '${widget.donation.organizationName}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppTheme.childHistoryPendingDark,
                                  ),
                        ),
                      ),
                      Text(
                        '${widget.donation.date.formatDate(locals)} - ${locals.childHistoryToBeApproved}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color:
                                  widget.donation.state == DonationState.pending
                                      ? DonationState.getAmountColor(
                                          widget.donation.state,
                                        )
                                      : AppTheme.givtPurple,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: DonationState.getAmountColor(widget.donation.state),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
