import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

const _recurringFrequencies = [
  ExternalDonationFrequency.weekly,
  ExternalDonationFrequency.monthly,
  ExternalDonationFrequency.halfYearly,
  ExternalDonationFrequency.yearly,
];

/// Includes [ExternalDonationFrequency.quarterly] for editing legacy donations.
const manageRecurringFrequencies = [
  ExternalDonationFrequency.weekly,
  ExternalDonationFrequency.monthly,
  ExternalDonationFrequency.quarterly,
  ExternalDonationFrequency.halfYearly,
  ExternalDonationFrequency.yearly,
];

class ExternalDonationFrequencyDropdown extends StatelessWidget {
  const ExternalDonationFrequencyDropdown({
    required this.value,
    required this.onChanged,
    this.label,
    this.frequencies,
    super.key,
  });

  final ExternalDonationFrequency? value;
  final ValueChanged<ExternalDonationFrequency> onChanged;
  final String? label;
  final List<ExternalDonationFrequency>? frequencies;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return FunInputDropdown<ExternalDonationFrequency>(
      label: label ?? locals.externalDonationsCreateFrequencyLabel,
      value: value,
      items: frequencies ?? _recurringFrequencies,
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

  /// Maps API frequencies to a value supported by [frequencies] (or create list).
  static ExternalDonationFrequency frequencyForEditor(
    ExternalDonationFrequency frequency, {
    List<ExternalDonationFrequency> supported = manageRecurringFrequencies,
  }) {
    if (frequency == ExternalDonationFrequency.once) {
      return ExternalDonationFrequency.monthly;
    }
    if (!supported.contains(frequency)) {
      return ExternalDonationFrequency.monthly;
    }
    return frequency;
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
