import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/children/overview/widgets/children_loading_page.dart';
import 'package:givt_app/features/children/overview/widgets/download_givt_for_kids_app_widget.dart';
import 'package:givt_app/features/children/overview/widgets/family_available_page.dart';
import 'package:givt_app/features/children/overview/widgets/no_children_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class FamilyOverviewPage extends StatelessWidget {
  const FamilyOverviewPage({super.key});

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
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: state is FamilyOverviewUpdatedState &&
                    !state.hasChildren &&
                    state.isAdultSingle
                ? const SizedBox()
                : state is FamilyOverviewLoadingState
                    ? const SizedBox()
                    : Text(
                        context.l10n.childrenMyFamily,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w900,
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
              if (state is FamilyOverviewUpdatedState &&
                  (state.hasChildren || !state.isAdultSingle))
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: TextButton(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Icon(Icons.add, size: 20),
                        ),
                        Text(
                          context.l10n.addMember,
                          textAlign: TextAlign.start,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.givtBlue,
                                  ),
                        ),
                      ],
                    ),
                    onPressed: () => _addNewChild(context, state),
                  ),
                ),
            ],
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: buildFamilyOverviewBody(state, context),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: (state is FamilyOverviewUpdatedState &&
                  (state.hasChildren || !state.isAdultSingle))
              ? const DownloadGivtForKidsAppWidget()
              : null,
        );
      },
    );
  }

  Widget buildFamilyOverviewBody(
      FamilyOverviewState state, BuildContext context) {
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

  void _addNewChild(BuildContext context, FamilyOverviewUpdatedState state) {
    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.addMemerClicked,
    );
    final familyExists = state.hasChildren || !state.isAdultSingle;
    context.pushReplacementNamed(Pages.addMember.name, extra: familyExists);
  }
}
