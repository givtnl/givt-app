import 'package:equatable/equatable.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';

class DonationGroup extends Equatable {
  const DonationGroup({
    required this.timeStamp,
    required this.organisationName,
    required this.donations,
    required this.amount,
    this.isGiftAidEnabled = false,
    this.isOnlineGiving = false,
    this.organisationTaxDeductible = false,
  });

  final DateTime? timeStamp;
  final String organisationName;
  final List<DonationItem> donations;
  final double amount;
  final bool isGiftAidEnabled;
  final bool isOnlineGiving;
  final bool organisationTaxDeductible;

  double get platformFeeAmount {
    final seenIds = <int>{};
    double sum = 0;
    for (final donation in donations) {
      final id = donation.platformFeeTransactionId;
      final fee = donation.platformFeeAmount;
      if (id != null && fee != null && !seenIds.contains(id)) {
        sum += fee;
        seenIds.add(id);
      }
    }
    return sum;
  }

  DonationGroup copyWith({
    DateTime? timeStamp,
    String? organisationName,
    List<DonationItem>? donations,
    double? amount,
    bool? isGiftAidEnabled,
    bool? organisationTaxDeductible,
  }) {
    return DonationGroup(
      timeStamp: timeStamp ?? this.timeStamp,
      organisationName: organisationName ?? this.organisationName,
      donations: donations ?? this.donations,
      amount: amount ?? this.amount,
      isGiftAidEnabled: isGiftAidEnabled ?? this.isGiftAidEnabled,
      organisationTaxDeductible: organisationTaxDeductible ?? this.organisationTaxDeductible,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'donations': donations.map((e) => e.toJson()).toList(),
      'amount': amount,
    };
  }

  @override
  List<Object?> get props => [
        timeStamp,
        organisationName,
        donations,
        amount,
        isGiftAidEnabled,
        organisationTaxDeductible,
        platformFeeAmount,
      ];
}
