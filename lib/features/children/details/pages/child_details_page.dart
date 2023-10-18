import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/details/cubit/child_details_cubit.dart';
import 'package:givt_app/features/children/details/widgets/child_details_item.dart';
import 'package:givt_app/features/children/details/widgets/child_giving_allowance_card.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ChildDetailsPage extends StatelessWidget {
  const ChildDetailsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildDetailsCubit, ChildDetailsState>(
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
                TextButton.icon(
                  icon: const Icon(Icons.edit),
                  label: Text(
                    //TODO: POEditor
                    'Edit',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.inputFieldBorderSelected,
                        ),
                  ),
                  onPressed: () {
                    context.pushNamed(
                      Pages.editChild.name,
                      extra: context.read<ChildDetailsCubit>(),
                    );
                  },
                ),
            ],
            automaticallyImplyLeading: false,
            backgroundColor: state is ChildDetailsFetchedState
                ? state.profileDetails.profile.monsterColor
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
                            color: state.profileDetails.profile.monsterColor,
                            child: ChildDetailsItem(
                              profile: state.profileDetails.profile,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ChildGivingAllowanceCard(
                            profileDetails: state.profileDetails,
                            onPressed: () {
                              context.pushNamed(
                                Pages.editChild.name,
                                extra: context.read<ChildDetailsCubit>(),
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
}
