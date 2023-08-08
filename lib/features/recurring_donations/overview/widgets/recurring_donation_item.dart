import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/util.dart';
import 'package:intl/intl.dart';

class RecurringDonationItem extends StatefulWidget {
  const RecurringDonationItem({
    required this.recurringDonation,
    required this.isExtended,
    required this.onTap,
    required this.onCancel,
    required this.onOverview,
    super.key,
  });

  final RecurringDonation recurringDonation;
  final bool isExtended;
  final void Function() onTap;
  final void Function() onCancel;
  final void Function() onOverview;
  @override
  State<RecurringDonationItem> createState() => _RecurringDonationItemState();
}

class _RecurringDonationItemState extends State<RecurringDonationItem> {
  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    const animationDuration = Duration(milliseconds: 300);
    final frequencies = [
      locals.setupRecurringGiftWeek,
      locals.setupRecurringGiftMonth,
      locals.setupRecurringGiftQuarter,
      locals.setupRecurringGiftHalfYear,
      locals.setupRecurringGiftYear
    ];
    String getFrequencyText() {
      final user = context.read<AuthCubit>().state.user;
      final currency = NumberFormat.simpleCurrency(
        name: Util.getCurrencyName(country: Country.fromCode(user.country)),
      );

      final result =
          '${locals.setupRecurringGiftText7} ${frequencies[widget.recurringDonation.frequency]} ${locals.recurringDonationYouGive} ${currency.currencySymbol} ${widget.recurringDonation.amountPerTurn.toStringAsFixed(2)}';

      return result;
    }

    String endsOnText() {
      final dateFormat = DateFormat('dd-MM-yyyy');
      final endsOn = locals.recurringDonationStops(
          dateFormat.format(widget.recurringDonation.endDate));
      return endsOn;
    }

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
        child: AnimatedContainer(
          duration: animationDuration,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.recurringDonation.collectGroup.type.color,
              width: 1,
            ),
          ),
          width: double.infinity,
          height: widget.isExtended ? 120 : 88,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        margin: const EdgeInsets.only(top: 3),
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color:
                              widget.recurringDonation.collectGroup.type.color,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Image.asset(
                          widget.recurringDonation.collectGroup.type.icon,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.recurringDonation.collectGroup.orgName,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          getFrequencyText(),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          endsOnText(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppTheme.givtDarkerGray),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                height: widget.isExtended ? 25 : 0,
                duration: animationDuration,
                child: AnimatedScale(
                  duration: animationDuration,
                  scale: widget.isExtended ? 1 : 0.1,
                  child: AnimatedOpacity(
                    opacity: widget.isExtended ? 1 : 0,
                    duration: animationDuration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              onPressed: widget.onCancel,
                              icon: const Icon(
                                Icons.stop_circle_outlined,
                                color: AppTheme.givtRed,
                              ),
                              label: Text(
                                locals.cancelRecurringDonation,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppTheme.givtRed,
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              onPressed: () {
                                widget.onOverview();
                              },
                              icon: const Icon(
                                Icons.list_rounded,
                              ),
                              label: Text(
                                locals.featureRecurringDonations3Title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
