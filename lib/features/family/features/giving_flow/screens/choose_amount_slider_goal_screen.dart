import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/giving_flow/collectgroup_details/cubit/collectgroup_details_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/models/transaction.dart';
import 'package:givt_app/features/family/features/giving_flow/widgets/family_goal_widget.dart';
import 'package:givt_app/features/family/features/giving_flow/widgets/slider_widget.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/family/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ChooseAmountSliderGoalScreen extends StatelessWidget {
  const ChooseAmountSliderGoalScreen({
    required this.group,
    super.key,
  });
  final ImpactGroup group;
  @override
  Widget build(BuildContext context) {
    final organisationDetailsState =
        context.watch<CollectGroupDetailsCubit>().state;
    final profilesCubit = context.read<ProfilesCubit>();
    final organisation = organisationDetailsState.collectgroup;
    final mediumId = organisationDetailsState.mediumId;
    final amountLeftToGoal = group.goal.goalAmount - group.goal.amount;
    final goalString = group.isFamilyGroup ? 'Family Goal' : 'Goal';

    return BlocConsumer<CreateTransactionCubit, CreateTransactionState>(
      listener: (context, state) async {
        if (state is CreateTransactionErrorState) {
          log(state.errorMessage);
          SnackBarHelper.showMessage(
            context,
            text: 'Cannot create transaction. Please try again later.',
            isError: true,
          );
        } else if (state is CreateTransactionSuccessState) {
          if (!context.mounted) {
            return;
          }

          context.pushReplacementNamed(
            FamilyPages.successCoin.name,
            extra: group.goal.isActive,
          );
        }
      },
      builder: (context, state) {
        final amountLeftWithDonation =
            amountLeftToGoal - state.amount.round() > 0
                ? (amountLeftToGoal - state.amount.round()).toInt()
                : 0;
        return FunScaffold(
          appBar: const FunTopAppBar(
            leading: GivtBackButtonFlat(),
            title: 'Give',
          ),
          body: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    FamilyGoalWidget(group, organisation),
                    const Spacer(),
                    const BodyMediumText(
                      'How much would you like to give?',
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              SliderWidget(state.amount, state.maxAmount),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/family/images/goal_flag.svg',
                    width: 24,
                  ),
                  const SizedBox(width: 8),
                  if (amountLeftWithDonation > 0)
                    Text.rich(
                      TextSpan(
                        text: '\$$amountLeftWithDonation',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: FamilyAppTheme.primary20,
                              fontWeight: FontWeight.w700,
                            ),
                        children: [
                          TextSpan(
                            text: ' to complete the $goalString',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: FamilyAppTheme.primary20,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  if (amountLeftWithDonation <= 0)
                    Text.rich(
                      TextSpan(
                        text: 'This donation will complete the\n$goalString',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: FamilyAppTheme.primary20,
                            ),
                      ),
                    ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 20),
              FunButton(
                isDisabled: state.amount == 0,
                text: 'Give',
                isLoading: state is CreateTransactionUploadingState,
                onTap: state.amount == 0
                    ? null
                    : () async {
                        if (state is CreateTransactionUploadingState) {
                          return;
                        }
                        final transaction = Transaction(
                          userId: profilesCubit.state.activeProfile.id,
                          mediumId: mediumId,
                          amount: state.amount,
                          goalId: group.goal.id,
                        );

                        await context
                            .read<CreateTransactionCubit>()
                            .createTransaction(transaction: transaction);
                      },
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.donateToThisFamilyGoalPressed,
                  parameters: {
                    AnalyticsHelper.goalKey: organisation.name,
                    AnalyticsHelper.amountKey: state.amount,
                    AnalyticsHelper.walletAmountKey:
                        profilesCubit.state.activeProfile.wallet.balance,
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
