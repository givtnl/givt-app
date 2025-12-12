import 'package:equatable/equatable.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';

class ReviewDonationsUIModel extends Equatable {
  const ReviewDonationsUIModel({
    required this.pendingDonations,
    required this.totalAmount,
    required this.isLoading,
    this.error,
  });

  factory ReviewDonationsUIModel.loading() {
    return const ReviewDonationsUIModel(
      pendingDonations: [],
      totalAmount: 0,
      isLoading: true,
    );
  }

  factory ReviewDonationsUIModel.error(String error) {
    return ReviewDonationsUIModel(
      pendingDonations: const [],
      totalAmount: 0,
      isLoading: false,
      error: error,
    );
  }

  factory ReviewDonationsUIModel.fromDonations(
    List<DonationItem> pendingDonations,
  ) {
    final totalAmount = pendingDonations.fold<double>(
      0,
      (sum, donation) => sum + donation.amount,
    );

    return ReviewDonationsUIModel(
      pendingDonations: pendingDonations,
      totalAmount: totalAmount,
      isLoading: false,
      error: null,
    );
  }

  final List<DonationItem> pendingDonations;
  final double totalAmount;
  final bool isLoading;
  final String? error;

  ReviewDonationsUIModel copyWith({
    List<DonationItem>? pendingDonations,
    double? totalAmount,
    bool? isLoading,
    String? error,
  }) {
    return ReviewDonationsUIModel(
      pendingDonations: pendingDonations ?? this.pendingDonations,
      totalAmount: totalAmount ?? this.totalAmount,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        pendingDonations,
        totalAmount,
        isLoading,
        error,
      ];
}
