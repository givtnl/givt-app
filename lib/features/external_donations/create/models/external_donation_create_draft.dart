import 'package:equatable/equatable.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';
import 'package:givt_app/shared/models/collect_group.dart';

/// In-memory draft for the external-donation create flow.
class ExternalDonationCreateDraft extends Equatable {
  const ExternalDonationCreateDraft({
    this.organisationName = '',
    this.selectedOrganisation,
    this.isCustomOrganisation = false,
    this.amountInput = '',
    this.taxDeductible = false,
    this.isOneOff,
    this.frequency,
    this.dateMade,
    this.seriesStartDate,
  });

  final String organisationName;
  final CollectGroup? selectedOrganisation;
  final bool isCustomOrganisation;
  final String amountInput;
  final bool taxDeductible;
  final bool? isOneOff;
  final ExternalDonationFrequency? frequency;
  final DateTime? dateMade;
  final DateTime? seriesStartDate;

  bool get hasOrganisation => organisationName.trim().isNotEmpty;

  double? get parsedAmount {
    final normalized = amountInput.replaceAll(',', '.').trim();
    if (normalized.isEmpty) {
      return null;
    }
    return double.tryParse(normalized);
  }

  bool get isAmountValid {
    final amount = parsedAmount;
    return amount != null && amount > 0;
  }

  bool get isFrequencyStepValid => isOneOff != null;

  bool get isDonationTypeStepValid =>
      isAmountValid &&
      isOneOff != null &&
      (isOneOff == true || isRecurringFrequencyValid);

  bool get isRecurringFrequencyValid =>
      isOneOff == false &&
      frequency != null &&
      frequency != ExternalDonationFrequency.once;

  bool get isOneOffDateValid => isOneOff == true && dateMade != null;

  bool get isSeriesStartDateValid =>
      isOneOff == false && seriesStartDate != null;

  ExternalDonationCreateDraft copyWith({
    String? organisationName,
    CollectGroup? selectedOrganisation,
    bool? isCustomOrganisation,
    String? amountInput,
    bool? taxDeductible,
    bool? isOneOff,
    ExternalDonationFrequency? frequency,
    DateTime? dateMade,
    DateTime? seriesStartDate,
    bool clearSelectedOrganisation = false,
    bool clearFrequency = false,
    bool clearDates = false,
  }) {
    return ExternalDonationCreateDraft(
      organisationName: organisationName ?? this.organisationName,
      selectedOrganisation: clearSelectedOrganisation
          ? null
          : selectedOrganisation ?? this.selectedOrganisation,
      isCustomOrganisation:
          isCustomOrganisation ?? this.isCustomOrganisation,
      amountInput: amountInput ?? this.amountInput,
      taxDeductible: taxDeductible ?? this.taxDeductible,
      isOneOff: isOneOff ?? this.isOneOff,
      frequency: clearFrequency ? null : frequency ?? this.frequency,
      dateMade: clearDates ? null : dateMade ?? this.dateMade,
      seriesStartDate:
          clearDates ? null : seriesStartDate ?? this.seriesStartDate,
    );
  }

  @override
  List<Object?> get props => [
        organisationName,
        selectedOrganisation,
        isCustomOrganisation,
        amountInput,
        taxDeductible,
        isOneOff,
        frequency,
        dateMade,
        seriesStartDate,
      ];
}
