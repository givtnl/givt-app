import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/details/cubit/child_details_cubit.dart';
import 'package:givt_app/features/children/details/widgets/child_cancel_rga_failed_dialog.dart';
import 'package:givt_app/features/children/details/widgets/child_cancel_rga_success_dialog.dart';
import 'package:givt_app/features/children/details/widgets/child_details_item.dart';
import 'package:givt_app/features/children/details/widgets/child_giving_allowance_card.dart';
import 'package:givt_app/features/children/details/widgets/child_top_up_card.dart';
import 'package:givt_app/features/children/details/widgets/child_top_up_failure_dialog.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/children/overview/pages/add_top_up_page.dart';
import 'package:givt_app/features/children/overview/pages/edit_allowance_page.dart';
import 'package:givt_app/features/children/overview/pages/edit_allowance_success_page.dart';
import 'package:givt_app/features/children/overview/pages/models/edit_allowance_success_uimodel.dart';
import 'package:givt_app/features/children/overview/pages/models/top_up_success_uimodel.dart';
import 'package:givt_app/features/children/overview/pages/top_up_success_page.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ChildDetailsPage extends StatelessWidget {
  const ChildDetailsPage({
    super.key,
  });

  void _pushToEdit(BuildContext context) {
    context.pushNamed(
      FamilyPages.editChild.name,
      extra: [
        context.read<FamilyOverviewCubit>(),
        context.read<ChildDetailsCubit>(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChildDetailsCubit, ChildDetailsState>(
      listenWhen: (previous, current) {
        return current is ChildDetailsErrorState ||
            current is ChildEditGivingAllowanceSuccessState ||
            current is ChildTopUpFundsErrorState ||
            current is ChildCancelAllowanceErrorState ||
            current is ChildCancelAllowanceSuccessState ||
            current is ChildTopUpSuccessState;
      },
      buildWhen: (previous, current) {
        return current is ChildDetailsFetchingState ||
            current is ChildDetailsFetchedState;
      },
      listener: (context, state) {
        if (state is ChildDetailsErrorState) {
          SnackBarHelper.showMessage(
            context,
            text: state.errorMessage,
            isError: true,
          );
        } else if (state is ChildEditGivingAllowanceSuccessState) {
          Navigator.push(
            context,
            EditAllowanceSuccessPage(
              uiModel: EditAllowanceSuccessUIModel(
                amountWithCurrencySymbol: '\$${state.allowance}',
              ),
            ).toRoute(context),
          );
        } else if (state is ChildTopUpFundsErrorState) {
          showDialog<void>(
            context: context,
            builder: (_) => const TopUpFailureDialog(),
          );
        } else if (state is ChildTopUpSuccessState) {
          Navigator.push(
            context,
            TopUpSuccessPage(
              onClickButton: () => context
                ..read<FamilyOverviewCubit>().fetchFamilyProfiles()
                ..pop(),
              uiModel: TopUpSuccessUIModel(
                amountWithCurrencySymbol: '\$${state.amount}',
              ),
            ).toRoute(context),
          );
        } else if (state is ChildCancelAllowanceSuccessState) {
          showDialog<void>(
            context: context,
            builder: (_) => const ChildCancelRGASuccessDialog(),
          );
        } else if (state is ChildCancelAllowanceErrorState) {
          showDialog<void>(
            context: context,
            builder: (_) => const ChildCancelRGAFailedDialog(),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              BackButton(
                onPressed: () {
                  context.pop();
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.backClicked,
                  );
                },
              ),
              const Spacer(),
              if (state is ChildDetailsFetchedState)
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: TextButton.icon(
                    icon: const Icon(
                      Icons.edit,
                      color: AppTheme.inputFieldBorderSelected,
                    ),
                    label: Text(
                      context.l10n.budgetExternalGiftsEdit,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.inputFieldBorderSelected,
                          ),
                    ),
                    onPressed: () {
                      AnalyticsHelper.logEvent(
                        eventName:
                            AmplitudeEvents.childDetailsEditAppBarClicked,
                        eventProperties: {
                          'child_name': state.profileDetails.firstName,
                          'giving_allowance':
                              state.profileDetails.givingAllowance.amount,
                        },
                      );

                      _pushToEdit(context);
                    },
                  ),
                ),
            ],
            automaticallyImplyLeading: false,
            backgroundColor: state is ChildDetailsFetchedState
                ? AppTheme.givtLightBackgroundGreen
                : null,
          ),
          body: state is ChildDetailsFetchingState
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.sliderIndicatorFilled,
                  ),
                )
              : state is ChildDetailsFetchedState
                  ? Column(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            color: AppTheme.givtLightBackgroundGreen,
                            child: ChildDetailsItem(
                              profileDetails: state.profileDetails,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ChildGivingAllowanceCard(
                            profileDetails: state.profileDetails,
                            onPressed: () {
                              AnalyticsHelper.logEvent(
                                eventName:
                                    AmplitudeEvents.childDetailsEditCardClicked,
                                eventProperties: {
                                  'child_name': state.profileDetails.firstName,
                                  'giving_allowance': state
                                      .profileDetails.givingAllowance.amount,
                                },
                              );

                              _navigateToEditAllowanceScreen(
                                context,
                                state.profileDetails.givingAllowance.amount
                                    .toInt(),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: ChildTopUpCard(
                            onPressed: () {
                              AnalyticsHelper.logEvent(
                                eventName:
                                    AmplitudeEvents.childTopUpCardClicked,
                                eventProperties: {
                                  'child_name': state.profileDetails.firstName,
                                },
                              );
                              _navigateToTopUpScreen(context);
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    )
                  : Container(),
        );
      },
    );
  }

  double getBalance(BuildContext context) {
    var family = context.watch<FamilyOverviewCubit>().state;
    if (family is FamilyOverviewUpdatedState) {
      return family.profiles
          .firstWhere(
            (element) =>
                element.id ==
                (context.watch<ChildDetailsCubit>().state
                        as ChildDetailsFetchedState)
                    .profileDetails
                    .profile
                    .id,
          )
          .wallet
          .balance;
    }
    return (context.watch<ChildDetailsCubit>().state
            as ChildDetailsFetchedState)
        .profileDetails
        .profile
        .wallet
        .balance;
  }

  Future<void> _navigateToTopUpScreen(
    BuildContext context,
  ) async {
    final dynamic result = await Navigator.push(
      context,
      const AddTopUpPage(
        currency: r'$',
      ).toRoute(context),
    );
    if (result != null && result is int && context.mounted) {
      await context.read<ChildDetailsCubit>().topUp(result);
    }
  }

  Future<void> _navigateToEditAllowanceScreen(
    BuildContext context,
    int currentAllowance,
  ) async {
    final dynamic result = await Navigator.push(
      context,
      EditAllowancePage(
        fee: 0.65,
        currency: r'$',
        initialAllowance: currentAllowance,
        onCancel: () => context.read<ChildDetailsCubit>().cancelAllowance(),
      ).toRoute(context),
    );
    if (result != null && result is int && context.mounted) {
      await context.read<ChildDetailsCubit>().updateAllowance(result);
    }
  }
}
