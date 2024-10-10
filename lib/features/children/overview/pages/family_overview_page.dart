import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/children/overview/widgets/allowance_warning_dialog.dart';
import 'package:givt_app/features/children/overview/widgets/children_loading_page.dart';
import 'package:givt_app/features/children/overview/widgets/family_available_page.dart';
import 'package:givt_app/features/children/overview/widgets/no_children_page.dart';
import 'package:givt_app/features/children/utils/add_member_util.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
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
        return FunScaffold(
          minimumPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          appBar: FunTopAppBar(
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
                  onPressed: () => addNewMember(
                    context,
                  ),
                ),
            ],
          ),
          body: buildFamilyOverviewBody(state, context),
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
          onAddNewChildPressed: () => addNewMember(context),
        );
      }

      return const FamilyAvailablePage();
    }

    return const SizedBox();
  }

  Future<void> addNewMember(
    BuildContext context,
  ) async {
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.addMemberClicked,
      ),
    );

    final isMissingCardDetails =
        context.read<AuthCubit>().state.user.isMissingcardDetails;
    await AddMemberUtil.addMemberPushPages(
      context,
      showTopUp: !isMissingCardDetails,
    );
  }
}
