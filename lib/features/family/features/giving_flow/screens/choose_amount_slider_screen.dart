import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/collectgroup_details/cubit/collectgroup_details_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/collectgroup_details/models/collectgroup_details.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/models/transaction.dart';
import 'package:givt_app/features/family/features/giving_flow/screens/success_screen.dart';
import 'package:givt_app/features/family/features/giving_flow/widgets/slider_widget.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_give.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ChooseAmountSliderScreen extends StatelessWidget {
  const ChooseAmountSliderScreen({
    super.key,
    this.onCustomSuccess,
  });
  final void Function()? onCustomSuccess;
  @override
  Widget build(BuildContext context) {
    final flow = context.read<FlowsCubit>().state;
    final collectgroupState = context.watch<CollectGroupDetailsCubit>().state;
    final collectgroup = collectgroupState.collectgroup;
    final profilesCubit = context.read<ProfilesCubit>();
    final mediumId = collectgroupState.mediumId;

    return BlocConsumer<CreateTransactionCubit, CreateTransactionState>(
      listener: (context, state) {
        if (state is CreateTransactionErrorState) {
          log(state.errorMessage);
          SnackBarHelper.showMessage(
            context,
            text: 'Cannot create transaction. Please try again later.',
            isError: true,
          );
        } else if (state is CreateTransactionSuccessState) {
          if (onCustomSuccess != null) {
            Navigator.of(context).pushReplacement(
              SuccessScreen(onCustomSuccess: onCustomSuccess).toRoute(context),
            );
            return;
          }
          context.pushReplacementNamed(
            flow.isCoin
                ? FamilyPages.successCoin.name
                : FamilyPages.success.name,
          );
        }
      },
      builder: (context, state) {
        return FunScaffold(
          appBar: FunTopAppBar(
            title: collectgroup.name,
            leading: const GivtBackButtonFlat(),
            actions: [
              actionIcon(collectgroup),
            ],
          ),
          body: Column(
            children: [
              const Spacer(),
              titleText(state, collectgroup),
              const SizedBox(height: 8),
              topIcon(state, collectgroup),
              const SizedBox(height: 32),
              BlocBuilder<ProfilesCubit, ProfilesState>(
                builder: (context, profiles) {
                  return SliderWidget(
                    state.amount,
                    profiles.activeProfile.wallet.balance,
                  );
                },
              ),
              const Spacer(),
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
                        );

                        await context
                            .read<CreateTransactionCubit>()
                            .createTransaction(transaction: transaction);
                      },
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.giveToThisGoalPressed,
                  parameters: {
                    AnalyticsHelper.goalKey: collectgroup.name,
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

  Widget actionIcon(
    CollectGroupDetails collectgroup,
  ) {
    // Default icon for all organisations
    var icon = FontAwesomeIcons.earthAmericas;

    // Only church should have a different icon
    if (collectgroup.type == CollectGroupType.church) {
      icon = FontAwesomeIcons.church;
    }

    // Add some padding to move it away from the side
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: FaIcon(icon),
    );
  }

  Widget topIcon(
    CreateTransactionState state,
    CollectGroupDetails collectgroup,
  ) {
    // Show the default icon always for non-church organisations
    if (collectgroup.type != CollectGroupType.church || state.amount == 0) {
      return FunGive.secondary30();
    } else if (state.amount >= 1 && state.amount <= 10) {
      return FunIcon.bowlFood(
        circleColor: FamilyAppTheme.highlight95,
        iconColor: FamilyAppTheme.info30,
      );
    } else if (state.amount >= 11 && state.amount <= 20) {
      return FunIcon.book(
        circleColor: FamilyAppTheme.secondary95,
        iconColor: FamilyAppTheme.secondary30,
      );
    } else {
      return FunIcon.boxOpen();
    }
  }

  Widget titleText(
    CreateTransactionState state,
    CollectGroupDetails collectgroup,
  ) {
    var title = 'How much would you like to give?';

    // Don't show the different amount icons for other types then church
    if (collectgroup.type != CollectGroupType.church) {
      return TitleMediumText(
        title,
        textAlign: TextAlign.center,
      );
    }

    if (state.amount >= 1 && state.amount <= 10) {
      title = 'This could go towards some meals';
    } else if (state.amount >= 11 && state.amount <= 20) {
      title = 'This could go towards church supplies';
    } else if (state.amount >= 21) {
      title = 'This could go towards some care packages';
    }

    return TitleMediumText(
      title,
      textAlign: TextAlign.center,
    );
  }
}
