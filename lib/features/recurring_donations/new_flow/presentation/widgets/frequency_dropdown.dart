import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_input_dropdown.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/l10n/l10n.dart';

class FrequencyDropdown extends StatelessWidget {
  const FrequencyDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return FunInputDropdown<String>(
      value: value,
      items: [
        locals.recurringDonationsFrequenciesWeekly,
        locals.recurringDonationsFrequenciesMonthly,
        locals.recurringDonationsFrequenciesQuarterly,
        locals.recurringDonationsFrequenciesHalfYearly,
        locals.recurringDonationsFrequenciesYearly,
      ],
      hint: const Text('Select one'),
      onChanged: onChanged,
      itemBuilder: (context, option) => Padding(
        padding: const EdgeInsets.only(left: 12),
        child: LabelLargeText(option),
      ),
    );
  }
} 