import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/overview/cubit/children_overview_cubit.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/features/children/overview/widgets/child_item.dart';
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
        actions: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: BackButton(
                onPressed: () {
                  context.pop();
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.backClicked,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SvgPicture.asset(
                'assets/images/logo_blue.svg',
              ),
            ),
          ),
          const Spacer(),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          BlocBuilder<ChildrenOverviewCubit, ChildrenOverviewState>(
            builder: (context, state) {
              if (state is ChildrenOverviewUpdatedState &&
                  state.displayAllowanceInfo) {
                return _buildDisclaimer(context.l10n, context, state.profiles);
              } else {
                return const SizedBox();
              }
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
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
                      return SingleChildScrollView(
                        child: Column(
                          children: state.profiles
                              .map(
                                (profile) => ChildItem(
                                  profile: profile,
                                ),
                              )
                              .toList(),
                        ),
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 35, right: 35, bottom: 30),
        child: ElevatedButton(
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
          child: Text(
            context.l10n.createChildAddProfileButton,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoChildrenWidget(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            //TODO: POEditor
            'Once you create a child profile, you will be able see them here and use the Givt4Kids companion app.',
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

  Widget _buildDisclaimer(AppLocalizations locals, BuildContext context,
          List<Profile> profiles) =>
      Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppTheme.givtLightYellow,
                border: Border.all(
                  color: AppTheme.givtKidsYellow,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            margin:
                const EdgeInsets.only(bottom: 0, top: 10, left: 20, right: 20),
            child: Row(
              children: [
                const Icon(Icons.info, color: AppTheme.givtBlue, size: 30),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: RichText(
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: locals.cannotSeeAllowance,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.givtBlue,
                          ),
                        ),
                        TextSpan(
                          text: locals.allowanceTakesTime,
                          style: const TextStyle(color: AppTheme.givtBlue),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            child: IconButton(
              padding: EdgeInsets.zero,
              alignment: Alignment.topCenter,
              onPressed: () {
                context
                    .read<ChildrenOverviewCubit>()
                    .removeDisclaimer(profiles);
                AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.infoGivingAllowanceDismissed);
              },
              icon: SvgPicture.asset(
                'assets/images/notification_kids_allowance_dismiss.svg',
                height: 24,
              ),
            ),
          ),
        ],
      );
}
