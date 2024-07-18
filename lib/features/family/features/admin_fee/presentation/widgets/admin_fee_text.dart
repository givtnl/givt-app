import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/features/admin_fee/application/admin_fee_cubit.dart';
import 'package:givt_app/features/family/features/admin_fee/presentation/widgets/admin_fee_text_layout.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';

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
  final AdminFeeCubit _adminFeeCubit = getIt<AdminFeeCubit>();

  @override
  void initState() {
    super.initState();
    _adminFeeCubit.init(widget.amount);
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _adminFeeCubit,
      onInitial: (context) => const SizedBox.shrink(),
      onData: (context, uiModel) {
        return widget.amount > 0
            ? AdminFeeTextLayout(
                uiModel: uiModel,
                isMonthly: widget.isMonthly,
                isMultipleChildren: widget.isMultipleChildren,
                textStyle: widget.textStyle,
              )
            : const SizedBox.shrink();
      },
    );
  }
}
