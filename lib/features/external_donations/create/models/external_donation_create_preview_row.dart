import 'package:equatable/equatable.dart';

/// One row in the create-flow History Item preview (Figma).
class ExternalDonationCreatePreviewRow extends Equatable {
  const ExternalDonationCreatePreviewRow({
    required this.organisationName,
    this.typeTagLabel,
    this.amountLabel,
    this.primarySubtitle,
    this.dateLabel,
    this.secondarySubtitle,
    this.isUpcoming = false,
    this.isCompleted = false,
  });

  final String organisationName;
  /// Green pill on the History Item (Figma: "Ext. donation"), not frequency.
  final String? typeTagLabel;
  final String? amountLabel;
  /// Frequency / donation type (e.g. One-off, Monthly).
  final String? primarySubtitle;
  /// Gift date; rendered as label/small + neutralVariant50.
  final String? dateLabel;
  final String? secondarySubtitle;
  final bool isUpcoming;
  final bool isCompleted;

  @override
  List<Object?> get props => [
        organisationName,
        typeTagLabel,
        amountLabel,
        primarySubtitle,
        dateLabel,
        secondarySubtitle,
        isUpcoming,
        isCompleted,
      ];
}
