import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/admin_fee/presentation/models/admin_fee_uimodel.dart';

class AdminFeeTextLayout extends StatelessWidget {
  const AdminFeeTextLayout({
    required this.uiModel,
    super.key,
    this.themeData,
    this.isMonthly = false,
    this.isMultipleChildren = false,
    this.textStyle,
  });

  final AdminFeeUIModel uiModel;
  final ThemeData? themeData;
  final TextStyle? textStyle;
  final bool isMonthly;
  final bool isMultipleChildren;

  @override
  Widget build(BuildContext context) {
    final theme = themeData ?? Theme.of(context);
    final perchild = isMultipleChildren ? ' per child' : '';
    final feeString = uiModel.fee.toStringAsFixed(2);
    final monthlyText = 'Admin fee of \$$feeString applies$perchild monthly';
    final nonMonthlyText = 'An admin fee of \$$feeString will be added';
    return Text(
      isMonthly ? monthlyText : nonMonthlyText,
      style: textStyle ??
          theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
