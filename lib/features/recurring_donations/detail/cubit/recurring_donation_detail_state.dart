part of 'recurring_donation_detail_cubit.dart';

/// UI Model for the recurring donation detail screen
class RecurringDonationDetailUIModel {
  const RecurringDonationDetailUIModel({
    required this.organizationName,
    required this.organizationIcon,
    required this.totalDonated,
    required this.remainingTime,
    required this.endDate,
    required this.progress,
    required this.history,
    required this.isLoading,
    this.error,
    this.monthsHelped,
  });

  final String organizationName;
  final String organizationIcon;
  final double totalDonated;
  final String remainingTime;
  final DateTime? endDate;
  final DonationProgress? progress;
  final List<DonationHistoryItem> history;
  final bool isLoading;
  final String? error;
  final int? monthsHelped;

  bool get hasError => error != null;
  bool get hasEndDate => endDate != null;
  bool get hasProgress => progress != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecurringDonationDetailUIModel &&
        other.organizationName == organizationName &&
        other.organizationIcon == organizationIcon &&
        other.totalDonated == totalDonated &&
        other.remainingTime == remainingTime &&
        other.endDate == endDate &&
        other.progress == progress &&
        other.history == history &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.monthsHelped == monthsHelped;
  }

  @override
  int get hashCode {
    return organizationName.hashCode ^
        organizationIcon.hashCode ^
        totalDonated.hashCode ^
        remainingTime.hashCode ^
        endDate.hashCode ^
        progress.hashCode ^
        history.hashCode ^
        isLoading.hashCode ^
        error.hashCode ^
        monthsHelped.hashCode;
  }

  RecurringDonationDetailUIModel copyWith({
    String? organizationName,
    String? organizationIcon,
    double? totalDonated,
    String? remainingTime,
    DateTime? endDate,
    DonationProgress? progress,
    List<DonationHistoryItem>? history,
    bool? isLoading,
    String? error,
    int? monthsHelped,
  }) {
    return RecurringDonationDetailUIModel(
      organizationName: organizationName ?? this.organizationName,
      organizationIcon: organizationIcon ?? this.organizationIcon,
      totalDonated: totalDonated ?? this.totalDonated,
      remainingTime: remainingTime ?? this.remainingTime,
      endDate: endDate ?? this.endDate,
      progress: progress ?? this.progress,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      monthsHelped: monthsHelped ?? this.monthsHelped,
    );
  }
}

/// Progress information for donations with end dates
class DonationProgress {
  const DonationProgress({
    required this.completed,
    required this.total,
  });

  final int completed;
  final int total;

  double get percentage => total > 0 ? completed / total : 0.0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DonationProgress &&
        other.completed == completed &&
        other.total == total;
  }

  @override
  int get hashCode => completed.hashCode ^ total.hashCode;
}

/// History item for donation instances
class DonationHistoryItem {
  const DonationHistoryItem({
    required this.amount,
    required this.date,
    required this.status,
    required this.icon,
  });

  final double amount;
  final DateTime date;
  final DonationStatus status;
  final String icon;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DonationHistoryItem &&
        other.amount == amount &&
        other.date == date &&
        other.status == status &&
        other.icon == icon;
  }

  @override
  int get hashCode => amount.hashCode ^ date.hashCode ^ status.hashCode ^ icon.hashCode;
}

/// Status of a donation instance
enum DonationStatus {
  upcoming,
  completed,
  pending,
}

/// Custom states for the recurring donation detail screen
sealed class RecurringDonationDetailCustom {
  const RecurringDonationDetailCustom();

  const factory RecurringDonationDetailCustom.manageDonation() = ManageDonation;
}

final class ManageDonation extends RecurringDonationDetailCustom {
  const ManageDonation();
}
