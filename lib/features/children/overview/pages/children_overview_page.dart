import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/overview/cubit/children_overview_cubit.dart';
import 'package:givt_app/features/children/overview/widgets/children_available_page.dart';
import 'package:givt_app/features/children/overview/widgets/children_loading_page.dart';
import 'package:givt_app/features/children/overview/widgets/no_children_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ChildrenOverviewPage extends StatelessWidget {
  const ChildrenOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChildrenOverviewCubit, ChildrenOverviewState>(
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
        return Scaffold(
          appBar: AppBar(
            title:
                state is ChildrenOverviewUpdatedState && state.profiles.isEmpty
                    ? const SizedBox()
                    : Text(
                        context.l10n.childrenMyFamily,
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
              if (state is ChildrenOverviewUpdatedState &&
                  state.profiles.isNotEmpty)
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
                          context.l10n.childrenAddChild,
                          textAlign: TextAlign.start,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.givtBlue,
                                  ),
                        ),
                      ],
                    ),
                    onPressed: () => _addNewChild(context),
                  ),
                ),
            ],
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: state is ChildrenOverviewLoadingState
                ? const ChildrenLoadingPage()
                : state is ChildrenOverviewUpdatedState
                    ? state.profiles.isEmpty
                        ? NoChildrenPage(
                            onAddNewChildPressed: () => _addNewChild(context),
                          )
                        : ChildrenAvailablePage(
                            profiles: state.profiles,
                          )
                    : Container(),
          ),
        );
      },
    );
  }

  void _addNewChild(BuildContext context) {
    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.addChildProfile,
    );
    context.pushNamed(Pages.addMember.name);
  }
}
