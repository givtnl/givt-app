import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/overview/cubit/children_overview_cubit.dart';
import 'package:givt_app/features/children/overview/widgets/children_overview_widget.dart';
import 'package:givt_app/features/children/vpc/cubit/vpc_cubit.dart';
import 'package:givt_app/features/children/vpc/widgets/vpc_intro_item_image.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ChildrenOverviewPage extends StatelessWidget {
  const ChildrenOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          //TODFO: POEditor
          'My Family',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        leading: BackButton(
          onPressed: () {
            context.pop();
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.backClicked,
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: TextButton.icon(
              icon: const Icon(Icons.add),
              label: Text(
                //TODO: POEditor
                'Add child',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.givtBlue,
                    ),
              ),
              onPressed: () {
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.addChildProfile,
                );
                if (context.read<VPCCubit>().vpcGained) {
                  context.goNamed(Pages.createChild.name);
                } else {
                  context.goNamed(Pages.giveVPC.name);
                }
              },
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: BlocConsumer<ChildrenOverviewCubit, ChildrenOverviewState>(
          listener: (context, state) {
            log('children overview state changed on $state');
            if (state is ChildrenOverviewErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage,
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Theme.of(context).errorColor,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ChildrenOverviewLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChildrenOverviewUpdatedState) {
              if (state.profiles.isEmpty) {
                return _buildNoChildrenWidget(context);
              } else {
                return Column(
                  children: [
                    ChildrenOverviewWidget(
                      profiles: state.profiles, //.take(2).toList(),
                    ),

                    /// HISTORY WIDGET GOES HERE
                    /// FamilyHistory(children: state.profiles)
                  ],
                );
              }
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _buildNoChildrenWidget(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.l10n.noChildProfilesError,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(flex: 1),
          const VPCIntroItemImage(
            background: 'assets/images/vpc_intro_givt4kids_bg.svg',
            foreground: 'assets/images/vpc_intro_givt4kids.svg',
          ),
          const Spacer(flex: 2),
        ],
      );
}
