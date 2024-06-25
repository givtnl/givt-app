import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/pages.dart';
import 'package:givt_app/features/family/features/flows/cubit/flow_type.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/widgets/profile_item.dart';
import 'package:givt_app/features/family/features/profiles/widgets/profiles_empty_state_widget.dart';
import 'package:givt_app/features/family/shared/widgets/coin_widget.dart';
import 'package:givt_app/features/family/shared/widgets/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/givt_elevated_secondary_button.dart';
import 'package:givt_app/features/family/shared/widgets/top_app_bar.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/snack_bar_helper.dart';
import 'package:go_router/go_router.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({
    super.key,
  });

  static const int maxVivibleProfiles = 6;

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final flow = context.read<FlowsCubit>().state;
    context.read<ProfilesCubit>().fetchAllProfiles();

    List<Widget> createGridItems(List<Profile> profiles) {
      final gridItems = <Widget>[];
      for (var i = 0;
          i < profiles.length && i < ProfileSelectionScreen.maxVivibleProfiles;
          i++) {
        gridItems.add(
          GestureDetector(
            onTap: () {
              context.read<ProfilesCubit>().fetchProfile(profiles[i].id, true);
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.profilePressed,
                eventProperties: {
                  'profile_name':
                      '${profiles[i].firstName} ${profiles[i].lastName}',
                },
              );

              if (flow.isQRCode) {
                context.pushNamed(FamilyPages.camera.name);
                return;
              }
              if (flow.isRecommendation) {
                context.pushNamed(FamilyPages.recommendationStart.name);
                return;
              }
              if (flow.flowType == FlowType.deepLinkCoin) {
                context.pushNamed(FamilyPages.familyChooseAmountSlider.name);
                return;
              }
              if (flow.isCoin) {
                context.pushNamed(FamilyPages.scanNFC.name);
                return;
              }

              context.pushReplacementNamed(FamilyPages.wallet.name);
            },
            child: ProfileItem(
              name: profiles[i].firstName,
              imageUrl: profiles[i].pictureURL,
            ),
          ),
        );
      }
      return gridItems;
    }

    return BlocConsumer<ProfilesCubit, ProfilesState>(
      listener: (context, state) {
        if (state is ProfilesExternalErrorState) {
          log(state.errorMessage);
          SnackBarHelper.showMessage(
            context,
            text: 'Cannot download profiles. Please try again later.',
            isError: true,
          );
        } else if (state is ProfilesNotSetupState) {
          context.pushNamed(FamilyPages.childrenOverview.name);
        } else if (state is ProfilesNeedsRegistration) {
          if (context.read<RegistrationBloc>().state.status ==
              RegistrationStatus.createStripeAccount) {
            context.goNamed(
              FamilyPages.creditCardDetails.name,
              extra: context.read<RegistrationBloc>(),
            );
          } else {
            context.pushNamed(FamilyPages.registrationUS.name);
          }
        }
      },
      listenWhen: (previous, current) =>
          current is ProfilesNotSetupState ||
          current is ProfilesNeedsRegistration,
      buildWhen: (previous, current) =>
          current is! ProfilesNotSetupState &&
          current is! ProfilesNeedsRegistration,
      builder: (context, state) {
        final gridItems = createGridItems(
          state.profiles.where((e) => e.type == 'Child').toList(),
        );
        return Scaffold(
          appBar: TopAppBar(
            title: 'Who would like to give?',
            actions: [
              if (flow.isCoin) const CoinWidget(),
            ],
          ),
          body: state is ProfilesLoadingState
              ? const CustomCircularProgressIndicator()
              : state.children.isEmpty && state.parents.isEmpty
                  ? ProfilesEmptyStateWidget(
                      onRetry: () => context
                          .read<ProfilesCubit>()
                          .fetchAllProfiles(checkRegistrationAndSetup: true),
                    )
                  : SafeArea(
                      minimum: const EdgeInsets.only(bottom: 40),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            if (gridItems.isNotEmpty)
                              Expanded(
                                child: GridView.count(
                                  childAspectRatio: 0.74,
                                  crossAxisCount: gridItems.length < 3
                                      ? gridItems.length
                                      : 3,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20,
                                  children: gridItems,
                                ),
                              ),
                            const SizedBox(height: 8),
                            GivtElevatedSecondaryButton(
                              onTap: () async {
                                await AnalyticsHelper.logEvent(
                                  eventName:
                                      AmplitudeEvents.manageFamilyPressed,
                                );

                                if (!context.mounted) return;

                                await FamilyAuthUtils.authenticateUser(
                                  context,
                                  checkAuthRequest: CheckAuthRequest(
                                    navigate: (context, {isUSUser}) async {
                                      await context.pushNamed(
                                        FamilyPages.childrenOverview.name,
                                      );
                                    },
                                  ),
                                );
                              },
                              text: 'Manage Family',
                              leftIcon: const FaIcon(
                                FontAwesomeIcons.sliders,
                                color: AppTheme.primary30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    AnalyticsHelper.setFamilyAppTracking();
  }
}
