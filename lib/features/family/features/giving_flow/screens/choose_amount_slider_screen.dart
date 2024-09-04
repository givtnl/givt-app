import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/models/transaction.dart';
import 'package:givt_app/features/family/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/widgets/organisation_widget.dart';
import 'package:givt_app/features/family/features/giving_flow/widgets/slider_widget.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button.dart';
import 'package:givt_app/features/family/shared/widgets/content/coin_widget.dart';
import 'package:givt_app/features/family/shared/widgets/content/wallet.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ChooseAmountSliderScreen extends StatelessWidget {
  const ChooseAmountSliderScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final flow = context.read<FlowsCubit>().state;
    final organisationDetailsState =
        context.watch<OrganisationDetailsCubit>().state;
    final organisation = organisationDetailsState.organisation;
    final profilesCubit = context.read<ProfilesCubit>();
    final mediumId = organisationDetailsState.mediumId;

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
          context.pushReplacementNamed(
            flow.isCoin
                ? FamilyPages.successCoin.name
                : FamilyPages.success.name,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: flow.isQRCode || flow.isRecommendation ? 85 : null,
            automaticallyImplyLeading: false,
            leading: const GivtBackButton(),
            actions: [_getAppBarAction(flow)],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      OrganisationWidget(organisation),
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
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FunButton(
            isDisabled: state.amount == 0,
            text: flow.isCoin
                ? 'Activate the coin'
                : flow.isRecommendation
                    ? 'Finish donation'
                    : 'Next',
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

                    await AnalyticsHelper.logEvent(
                      eventName: AmplitudeEvents.giveToThisGoalPressed,
                      eventProperties: {
                        AnalyticsHelper.goalKey: organisation.name,
                        AnalyticsHelper.amountKey: state.amount,
                        AnalyticsHelper.walletAmountKey:
                            profilesCubit.state.activeProfile.wallet.balance,
                      },
                    );
                  },
          ),
        );
      },
    );
  }

  Widget _getAppBarAction(FlowsState flow) {
    if (flow.isQRCode || flow.isRecommendation) {
      return const Padding(
        padding: EdgeInsets.only(right: 16),
        child: Wallet(),
      );
    }
    if (flow.isCoin) {
      return const CoinWidget();
    }
    return const SizedBox();
  }
}
