import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/family/features/admin_fee/presentation/widgets/admin_fee_text.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/topup/cubit/topup_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/inputs/input_checkbox.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TopupInitialBottomSheet extends StatefulWidget {
  const TopupInitialBottomSheet({
    super.key,
  });

  @override
  State<TopupInitialBottomSheet> createState() =>
      _TopupInitialBottomSheetState();
}

class _TopupInitialBottomSheetState extends State<TopupInitialBottomSheet> {
  int topupAmount = 5;
  bool recurring = false;

  @override
  Widget build(BuildContext context) {
    final user = context.read<FamilyAuthCubit>().user!;
    final currentProfile = context.read<ProfilesCubit>().state.activeProfile;

    final currency = NumberFormat.simpleCurrency(
      name: Country.fromCode(user.country).currency,
    ).currencySymbol;

    return FunBottomSheet(
      title: 'Top up ${currentProfile.possessiveName} wallet',
      icon: primaryCircleWithIcon(
        circleSize: 140,
        iconData: FontAwesomeIcons.plus,
        iconSize: 48,
      ),
      content: Column(
        children: [
          const BodyMediumText(
            "How much would you like to add to your child's Wallet?",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FunCounter(
            prefix: currency,
            initialAmount: topupAmount,
            onAmountChanged: (amount) {
              setState(() {
                topupAmount = amount;
              });
            },
          ),
          const SizedBox(height: 8),
          if (currentProfile.wallet.givingAllowance.amount == 0)
            InputCheckbox(
              semanticsLabel: 'recurringCheckbox',
              label: 'Turn this into a monthly recurring amount',
              value: recurring,
              analyticsEvent: AmplitudeEvents.topupRecurringCheckboxChanged.toEvent(),
              onChanged: (value) {
                setState(() {
                  recurring = value ?? false;
                });
              },
            ),
        ],
      ),
      headlineContent: AdminFeeText(
        amount: topupAmount.toDouble(),
        isMonthly: recurring,
        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
      ),
      primaryButton: FunButton(
        text: 'Confirm',
        analyticsEvent: AmplitudeEvents.topupConfirmButtonClicked.toEvent(),
        onTap: () async {
          await context.read<TopupCubit>().addMoney(topupAmount, recurring);
        },
      ),
      closeAction: () {
        context.pop();
      },
    );
  }
}
