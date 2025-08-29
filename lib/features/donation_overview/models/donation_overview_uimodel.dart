import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';
import 'package:givt_app/features/donation_overview/models/donation_group.dart';
import 'package:givt_app/features/donation_overview/models/donation_status.dart';
import 'package:givt_app/shared/widgets/extensions/string_extensions.dart';
import 'package:intl/intl.dart';

class DonationOverviewUIModel extends Equatable {
  factory DonationOverviewUIModel.initial() {
    return const DonationOverviewUIModel(
      donations: [],
      isLoading: false,
      error: null,
      giftAidAmount: 0.0,
      monthlyGroups: [],
      donationGroups: [],
    );
  }

  factory DonationOverviewUIModel.loading() {
    return const DonationOverviewUIModel(
      donations: [],
      isLoading: true,
      error: null,
      giftAidAmount: 0.0,
      monthlyGroups: [],
      donationGroups: [],
    );
  }

  factory DonationOverviewUIModel.error(String error) {
    return DonationOverviewUIModel(
      donations: const [],
      isLoading: false,
      error: error,
      giftAidAmount: 0.0,
      monthlyGroups: const [],
      donationGroups: const [],
    );
  }

  factory DonationOverviewUIModel.fromDonations(List<DonationItem> donations) {
    if (donations.isEmpty) {
      return const DonationOverviewUIModel(
        donations: [],
        isLoading: false,
        error: null,
        giftAidAmount: 0.0,
        monthlyGroups: [],
        donationGroups: [],
      );
    }
    // Calculate GiftAid amount (25% of amount for GiftAid enabled donations)
    final giftAidAmount = donations
        .where((d) => d.isGiftAidEnabled)
        .fold<double>(
          0.0,
          (sum, d) =>
              d.status.type == DonationStatusType.completed ||
                  d.status.type == DonationStatusType.created ||
                  d.status.type == DonationStatusType.inProcess
              ? sum + (d.amount * 0.25)
              : sum,
        );

    // Group donations by month
    final monthlyGroups = <MonthlyGroup>[];
    final monthMap = <String, List<DonationItem>>{};

    for (final donation in donations) {
      if (donation.timeStamp != null) {
        final monthKey =
            '${donation.timeStamp!.year}-${donation.timeStamp!.month.toString().padLeft(2, '0')}';
        monthMap.putIfAbsent(monthKey, () => []).add(donation);
      }
    }

    // Convert to MonthlyGroup objects and sort by date (newest first)
    monthMap.forEach((key, monthDonations) {
      final parts = key.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);

      final monthAmount = monthDonations.fold<double>(
        0.0,
        (sum, d) =>
            d.status.type == DonationStatusType.completed ||
                d.status.type == DonationStatusType.created ||
                d.status.type == DonationStatusType.inProcess
            ? sum + d.amount
            : sum,
      );

      monthlyGroups.add(
        MonthlyGroup(
          year: year,
          month: month,
          donations: monthDonations,
          totalAmount: monthAmount,
        ),
      );
    });

    monthlyGroups.sort((a, b) {
      if (a.year != b.year) return b.year.compareTo(a.year);
      return b.month.compareTo(a.month);
    });

    // Group donations by timestamp and organization (similar to GivtGroup)
    final donationGroups = <DonationGroup>[];
    final groupMap = <String, List<DonationItem>>{};

    for (final donation in donations) {
      if (donation.timeStamp != null) {
        // Create a key based on timestamp and organization
        final groupKey =
            '${donation.timeStamp!.millisecondsSinceEpoch}_${donation.organisationName}';
        groupMap.putIfAbsent(groupKey, () => []).add(donation);
      }
    }

    // Convert to DonationGroup objects
    groupMap.forEach((key, groupDonations) {
      if (groupDonations.isNotEmpty) {
        final firstDonation = groupDonations.first;
        final groupAmount = groupDonations.fold<double>(
          0.0,
          (sum, d) => sum + d.amount,
        );

        donationGroups.add(
          DonationGroup(
            timeStamp: firstDonation.timeStamp,
            organisationName: firstDonation.organisationName,
            donations: groupDonations,
            amount: groupAmount,
            isGiftAidEnabled: firstDonation.isGiftAidEnabled,
            organisationTaxDeductible: firstDonation.organisationTaxDeductible,
            isOnlineGiving: firstDonation.donationType == 7,
            isRecurringDonation: firstDonation.donationType == 1,
          ),
        );
      }
    });

    // Sort donation groups by timestamp (newest first)
    donationGroups.sort((a, b) {
      if (a.timeStamp == null && b.timeStamp == null) return 0;
      if (a.timeStamp == null) return 1;
      if (b.timeStamp == null) return -1;
      return b.timeStamp!.compareTo(a.timeStamp!);
    });

    return DonationOverviewUIModel(
      donations: donations,
      isLoading: false,
      error: null,
      giftAidAmount: giftAidAmount,
      monthlyGroups: monthlyGroups,
      donationGroups: donationGroups,
    );
  }
  const DonationOverviewUIModel({
    required this.donations,
    required this.isLoading,
    required this.error,
    required this.giftAidAmount,
    required this.monthlyGroups,
    required this.donationGroups,
  });

  final List<DonationItem> donations;
  final bool isLoading;
  final String? error;
  final double giftAidAmount;
  final List<MonthlyGroup> monthlyGroups;
  final List<DonationGroup> donationGroups;

  DonationOverviewUIModel copyWith({
    List<DonationItem>? donations,
    bool? isLoading,
    String? error,
    double? giftAidAmount,
    List<MonthlyGroup>? monthlyGroups,
    List<DonationGroup>? donationGroups,
  }) {
    return DonationOverviewUIModel(
      donations: donations ?? this.donations,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      giftAidAmount: giftAidAmount ?? this.giftAidAmount,
      monthlyGroups: monthlyGroups ?? this.monthlyGroups,
      donationGroups: donationGroups ?? this.donationGroups,
    );
  }

  @override
  List<Object?> get props => [
    donations,
    isLoading,
    error,
    giftAidAmount,
    monthlyGroups,
    donationGroups,
  ];
}

class MonthlyGroup extends Equatable {
  const MonthlyGroup({
    required this.year,
    required this.month,
    required this.donations,
    required this.totalAmount,
  });

  final int year;
  final int month;
  final List<DonationItem> donations;
  final double totalAmount;

  String get monthName {
    final date = DateTime(year, month);
    return DateFormat.MMMM(Platform.localeName).format(date);
  }

  String get displayName {
    final date = DateTime(year, month);
    return DateFormat.yMMMM(Platform.localeName).format(date).capitalize();
  }

  @override
  List<Object?> get props => [year, month, donations, totalAmount];
}
