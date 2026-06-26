import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';

/// Chart buckets for the personal summary (Charity / Church / Campaign / Other).
enum GivingCategory {
  church,
  charity,
  campaign,
  other,
}

extension GivingCategoryX on GivingCategory {
  static const ordered = [
    GivingCategory.church,
    GivingCategory.charity,
    GivingCategory.campaign,
    GivingCategory.other,
  ];

  static GivingCategory fromCollectGroupType(CollectGroupType? type) {
    return switch (type) {
      CollectGroupType.church => GivingCategory.church,
      CollectGroupType.charities => GivingCategory.charity,
      CollectGroupType.campaign => GivingCategory.campaign,
      _ => GivingCategory.other,
    };
  }
}

class ChartSegment extends Equatable {
  const ChartSegment({
    required this.category,
    required this.amount,
    required this.fraction,
  });

  final GivingCategory category;
  final double amount;
  final double fraction;

  bool get hasData => amount > 0;

  @override
  List<Object?> get props => [category, amount, fraction];
}

class MonthlyCategoryRow extends Equatable {
  const MonthlyCategoryRow({
    required this.month,
    required this.amountsByCategory,
    required this.total,
  });

  final int month;
  final Map<GivingCategory, double> amountsByCategory;
  final double total;

  double amountFor(GivingCategory category) =>
      amountsByCategory[category] ?? 0;

  @override
  List<Object?> get props => [month, amountsByCategory, total];
}

class SplitBarData extends Equatable {
  const SplitBarData({
    required this.primaryAmount,
    required this.secondaryAmount,
    required this.primaryFraction,
    required this.secondaryFraction,
  });

  const SplitBarData.empty()
      : primaryAmount = 0,
        secondaryAmount = 0,
        primaryFraction = 0,
        secondaryFraction = 0;

  final double primaryAmount;
  final double secondaryAmount;
  final double primaryFraction;
  final double secondaryFraction;

  bool get hasData => primaryAmount > 0 || secondaryAmount > 0;

  @override
  List<Object?> get props => [
        primaryAmount,
        secondaryAmount,
        primaryFraction,
        secondaryFraction,
      ];
}
