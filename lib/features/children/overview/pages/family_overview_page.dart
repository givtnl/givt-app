import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/add_member/pages/add_member_counter_page.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/children/overview/widgets/allowance_warning_dialog.dart';
import 'package:givt_app/features/children/overview/widgets/children_loading_page.dart';
import 'package:givt_app/features/children/overview/widgets/family_available_page.dart';
import 'package:givt_app/features/children/overview/widgets/no_children_page.dart';
import 'package:givt_app/features/family/shared/widgets/layout/top_app_bar.dart';
import 'package:givt_app/shared/widgets/buttons/leading_back_button.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/utils/utils.dart';

class FamilyOverviewPage extends StatelessWidget {
  const FamilyOverviewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FamilyOverviewCubit, FamilyOverviewState>(
      listener: (context, state) {
        log('children overview state changed on $state');
        if (state is FamilyOverviewErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        if (state is FamilyOverviewAllowanceWarningState) {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return const AllowancesWarningDialog();
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: TopAppBar(
            title: state is FamilyOverviewUpdatedState &&
                    !state.hasChildren &&
                    state.isAdultSingle
                ? 'Set up Family'
                : 'Manage Family',
            actions: [
              if (state is FamilyOverviewUpdatedState &&
                  (state.hasChildren || !state.isAdultSingle))
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.userPlus,
                  ),
                  onPressed: () => _addNewChild(context, state),
                ),
            ],
            leading: const LeadingBackButton(),
          ),
          body: SafeArea(
            child: buildFamilyOverviewBody(state, context),
          ),
        );
      },
    );
  }

  Widget buildFamilyOverviewBody(
    FamilyOverviewState state,
    BuildContext context,
  ) {
    if (state is FamilyOverviewLoadingState) {
      return const ChildrenLoadingPage();
    }

    if (state is FamilyOverviewUpdatedState) {
      if (!state.hasChildren && state.isAdultSingle) {
        return NoChildrenPage(
          onAddNewChildPressed: () => _addNewChild(context, state),
        );
      }

      return const FamilyAvailablePage();
    }

    return const SizedBox();
  }

  void _addNewChild(
      BuildContext context, FamilyOverviewUpdatedState state) async {
    unawaited(AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.addMemerClicked,
    ));
    final dynamic result = await Navigator.push(
      context,
      const AddMemberCounterPage(
        initialAmount: 1,
      ).toRoute(context),
    );
    if (result != null && result is int && context.mounted) {
      // todo
    }
  }
}
