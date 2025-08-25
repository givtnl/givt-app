import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_input_dropdown.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/recurring_donations/create/models/recurring_donation_frequency.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';

class FrequencyDropdown extends StatelessWidget {
  const FrequencyDropdown({
    required this.value, required this.onChanged, super.key,
  });

  final RecurringDonationFrequency? value;
  final ValueChanged<RecurringDonationFrequency> onChanged;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    
    final frequencyOptions = [
      RecurringDonationFrequency.week,
      RecurringDonationFrequency.month,
      RecurringDonationFrequency.quarter,
      RecurringDonationFrequency.halfYear,
      RecurringDonationFrequency.year,
    ];

    return FunInputDropdown<RecurringDonationFrequency>(
      value: value,
      items: frequencyOptions,
      hint: Text(locals.recurringDonationsCreateFrequencyHint),
      onChanged: onChanged,
      itemBuilder: (context, option) => Padding(
        padding: const EdgeInsets.only(left: 12),
        child: LabelLargeText(_getFrequencyDisplayText(option, locals)),
      ),
    );
  }

  String _getFrequencyDisplayText(RecurringDonationFrequency frequency, AppLocalizations locals) {
    switch (frequency) {
      case RecurringDonationFrequency.week:
        return locals.recurringDonationsFrequenciesWeekly;
      case RecurringDonationFrequency.month:
        return locals.recurringDonationsFrequenciesMonthly;
      case RecurringDonationFrequency.quarter:
        return locals.recurringDonationsFrequenciesQuarterly;
      case RecurringDonationFrequency.halfYear:
        return locals.recurringDonationsFrequenciesHalfYearly;
      case RecurringDonationFrequency.year:
        return locals.recurringDonationsFrequenciesYearly;
    }
  }
} 