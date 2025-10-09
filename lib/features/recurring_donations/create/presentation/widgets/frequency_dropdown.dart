import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_input_dropdown.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart' as overview;
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';

class FrequencyDropdown extends StatelessWidget {
  const FrequencyDropdown({
    required this.value, required this.onChanged, super.key,
  });

  final overview.Frequency? value;
  final ValueChanged<overview.Frequency> onChanged;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    
    final frequencyOptions = [
      overview.Frequency.weekly,
      overview.Frequency.monthly,
      overview.Frequency.quarterly,
      overview.Frequency.halfYearly,
      overview.Frequency.yearly,
    ];

    return FunInputDropdown<overview.Frequency>(
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

  String _getFrequencyDisplayText(overview.Frequency frequency, AppLocalizations locals) {
    switch (frequency) {
      case overview.Frequency.weekly:
        return locals.recurringDonationsFrequenciesWeekly;
      case overview.Frequency.monthly:
        return locals.recurringDonationsFrequenciesMonthly;
      case overview.Frequency.quarterly:
        return locals.recurringDonationsFrequenciesQuarterly;
      case overview.Frequency.halfYearly:
        return locals.recurringDonationsFrequenciesHalfYearly;
      case overview.Frequency.yearly:
        return locals.recurringDonationsFrequenciesYearly;
      case overview.Frequency.daily:
      case overview.Frequency.none:
        return '';
    }
  }
} 