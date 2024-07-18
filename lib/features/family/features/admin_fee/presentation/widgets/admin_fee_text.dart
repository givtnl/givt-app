import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/features/admin_fee/repositories/admin_fee_repository.dart';

class AdminFeeText extends StatefulWidget {
  const AdminFeeText({
    required this.amount,
    super.key,
    this.theme,
    this.isMonthly = false,
    this.isMultipleChildren = false,
    this.textStyle,
  });

  final ThemeData? theme;
  final TextStyle? textStyle;
  final double amount;
  final bool isMonthly;
  final bool isMultipleChildren;

  @override
  State<AdminFeeText> createState() => _AdminFeeTextState();
}

class _AdminFeeTextState extends State<AdminFeeText> {
  final AdminFeeRepository _adminFeeRepository = getIt<AdminFeeRepository>();

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? Theme.of(context);
    final perchild = widget.isMultipleChildren ? ' per child' : '';
    final fee =
        _adminFeeRepository.getTotalFee(widget.amount).toStringAsFixed(2);
    final monthlyText = 'Admin fee of \$$fee applies$perchild monthly';
    final nonMonthlyText = 'An admin fee of \$$fee will be added';
    return Text(
      widget.isMonthly ? monthlyText : nonMonthlyText,
      style: widget.textStyle ??
          theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
