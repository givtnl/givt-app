import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/features/admin_fee/application/admin_fee_cubit.dart';
import 'package:givt_app/features/family/features/admin_fee/presentation/widgets/admin_fee_text_layout.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';

class AdminFeeText extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: getIt<AdminFeeCubit>()..setAmount(amount),
      onInitial: (context) => const SizedBox.shrink(),
      onData: (context, uiModel) {
        return amount > 0
            ? AdminFeeTextLayout(
                themeData: theme,
                uiModel: uiModel,
                isMonthly: isMonthly,
                isMultipleChildren: isMultipleChildren,
                textStyle: textStyle,
              )
            : const SizedBox.shrink();
      },
    );
  }
}
