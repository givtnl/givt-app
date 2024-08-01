import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/admin_fee/presentation/widgets/admin_fee_text.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/topup_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/content/amount_counter.dart';
import 'package:givt_app/features/family/shared/widgets/layout/givt_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TopupWalletBottomSheet extends StatefulWidget {
  const TopupWalletBottomSheet({super.key});

  @override
  State<TopupWalletBottomSheet> createState() => _TopupWalletBottomSheetState();
}

class _TopupWalletBottomSheetState extends State<TopupWalletBottomSheet> {
  int topupAmount = 5;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopupCubit, TopupState>(
      builder: (context, state) {
        switch (state.status) {
          case TopupStatus.initial:
            return showTopupSheet();
          case TopupStatus.loading:
            return showTopupLoadingSheet();
          case TopupStatus.done:
            return showTopupSuccessSheet();
          case TopupStatus.error:
            return showTopupErrorSheet();
        }
      },
    );
  }

  Widget showTopupErrorSheet() {
    return GivtBottomSheet(
      title: 'Oops, something went wrong',
      icon: errorCircleWithIcon(
        circleSize: 140,
        iconData: FontAwesomeIcons.triangleExclamation,
        iconSize: 48,
      ),
      content: Column(
        children: [
          Text(
            'We are having trouble getting the funds from your card. Please try again.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      primaryButton: GivtElevatedButton(
        text: 'Ok',
        onTap: () {
          context.read<TopupCubit>().restart();
        },
      ),
      closeAction: () {
        context.pop();
      },
    );
  }

  Widget showTopupSuccessSheet() {
    return GivtBottomSheet(
      title: 'Consider it done!',
      icon: primaryCircleWithIcon(
        circleSize: 140,
        iconData: FontAwesomeIcons.check,
        iconSize: 48,
      ),
      content: Column(
        children: [
          Text(
            "\$$topupAmount has been added to your child's Wallet",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      primaryButton: GivtElevatedButton(
        text: 'Done',
        onTap: () {
          context.read<ProfilesCubit>().fetchActiveProfile();
          context.pop();
        },
      ),
      closeAction: () {
        context.read<ProfilesCubit>().fetchActiveProfile();
        context.pop();
      },
    );
  }

  Widget showTopupLoadingSheet() {
    return GivtBottomSheet(
      title: 'Top up my wallet',
      icon: const CustomCircularProgressIndicator(),
      content: Column(
        children: [
          Text(
            "We're processing your top up",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget showTopupSheet() {
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
            onAmountChanged: (amount) => setState(() {
              topupAmount = amount;
            }),
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
