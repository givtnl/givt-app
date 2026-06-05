import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

const _recurringFrequencies = [
  ExternalDonationFrequency.weekly,
  ExternalDonationFrequency.monthly,
  ExternalDonationFrequency.halfYearly,
  ExternalDonationFrequency.yearly,
];

class ExternalDonationFrequencyDropdown extends StatelessWidget {
  const ExternalDonationFrequencyDropdown({
    required this.value,
    required this.onChanged,
    this.label,
    super.key,
  });

  final ExternalDonationFrequency? value;
  final ValueChanged<ExternalDonationFrequency> onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return FunInputDropdown<ExternalDonationFrequency>(
      label: label ?? locals.externalDonationsCreateFrequencyLabel,
      value: value,
      items: _recurringFrequencies,
      hint: Text(locals.recurringDonationsCreateFrequencyHint),
      onChanged: onChanged,
      itemBuilder: (context, option) => Padding(
        padding: const EdgeInsets.only(left: 12),
        child: LabelLargeText(_frequencyLabel(locals, option)),
      ),
    );
  }

  static String frequencyLabel(
    AppLocalizations locals,
    ExternalDonationFrequency frequency,
  ) {
    return _frequencyLabel(locals, frequency);
  }

  static String _frequencyLabel(
    AppLocalizations locals,
    ExternalDonationFrequency frequency,
  ) {
    switch (frequency) {
      case ExternalDonationFrequency.weekly:
        return locals.recurringDonationsFrequenciesWeekly;
      case ExternalDonationFrequency.monthly:
        return locals.recurringDonationsFrequenciesMonthly;
      case ExternalDonationFrequency.halfYearly:
        return locals.recurringDonationsFrequenciesHalfYearly;
      case ExternalDonationFrequency.yearly:
        return locals.recurringDonationsFrequenciesYearly;
      case ExternalDonationFrequency.once:
        return locals.externalDonationsCreateFrequencyOneOff;
      case ExternalDonationFrequency.quarterly:
        return locals.recurringDonationsFrequenciesQuarterly;
    }
  }
}
