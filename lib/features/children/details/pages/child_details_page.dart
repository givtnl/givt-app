import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/details/cubit/child_details_cubit.dart';
import 'package:givt_app/features/children/details/widgets/child_details_item.dart';
import 'package:givt_app/features/children/details/widgets/child_giving_allowance_card.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/children/overview/pages/edit_allowance_page.dart';
import 'package:givt_app/features/children/overview/pages/edit_allowance_success_page.dart';
import 'package:givt_app/features/children/overview/pages/models/edit_allowance_success_uimodel.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/extensions/string_extensions.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ChildDetailsPage extends StatelessWidget {
  const ChildDetailsPage({
    super.key,
  });

  void _pushToEdit(BuildContext context) {
    context.pushNamed(
      Pages.editChild.name,
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
            current is ChildEditGivingAllowanceSuccessState;
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
                    icon: const Icon(Icons.edit),
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
                        const Spacer(),
                      ],
                    )
                  : Container(),
        );
      },
    );
  }

  Future<void> _navigateToEditAllowanceScreen(
    BuildContext context,
    int currentAllowance,
  ) async {
    final dynamic result = await Navigator.push(
      context,
      EditAllowancePage(
        currency: r'$',
        initialAllowance: currentAllowance,
      ).toRoute(context),
    );
    if (result != null && result is int) {
      context.read<ChildDetailsCubit>().updateAllowance(result);
    }
  }
}
