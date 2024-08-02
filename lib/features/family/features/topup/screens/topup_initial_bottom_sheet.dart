import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/admin_fee/presentation/widgets/admin_fee_text.dart';
import 'package:givt_app/features/family/features/topup/cubit/topup_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/content/amount_counter.dart';
import 'package:givt_app/features/family/shared/widgets/layout/givt_bottom_sheet.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TopupInitialBottomSheet extends StatelessWidget {
  const TopupInitialBottomSheet({
    required this.topupAmount,
    required this.amountChanged,
    super.key,
  });

  final int topupAmount;
  final void Function(int) amountChanged;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;

    final currency = NumberFormat.simpleCurrency(
      name: Country.fromCode(user.country).currency,
    ).currencySymbol;

    return GivtBottomSheet(
      title: 'Top up my wallet',
      icon: primaryCircleWithIcon(
        circleSize: 140,
        iconData: FontAwesomeIcons.plus,
        iconSize: 48,
      ),
      content: Column(
        children: [
          Text(
            "How much would you like to add to your child's Wallet?",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AmountCounter(
            currency: currency,
            initialAmount: topupAmount,
            onAmountChanged: amountChanged,
          ),
        ],
      ),
      headlineContent: AdminFeeText(
        amount: topupAmount.toDouble(),
        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
      ),
      primaryButton: GivtElevatedButton(
        text: 'Confirm',
        onTap: () async {
          await context.read<TopupCubit>().topup(topupAmount);
        },
      ),
      closeAction: () {
        context.pop();
      },
    );
  }
}
