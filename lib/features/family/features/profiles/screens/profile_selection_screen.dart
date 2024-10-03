import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/notification/notification_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/flows/cubit/flow_type.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/widgets/parent_overview_widget.dart';
import 'package:givt_app/features/family/features/profiles/widgets/profile_item.dart';
import 'package:givt_app/features/family/features/profiles/widgets/profiles_empty_state_widget.dart';
import 'package:givt_app/features/family/features/topup/screens/empty_wallet_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/shared/widgets/theme/app_theme_switcher.dart';
import 'package:givt_app/utils/analytics_helper.dart';
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
  bool isCachedMembersBottomsheetUp = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfilesCubit>().fetchAllProfiles();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      // @TODO - This is a workaround to navigate to the correct page when
      // the app is opened from a notification and the user is authenticated,
      // but it should be refactored to use the GoRouter (or another solution)
      // In the EU this workaround is in the file home_page.dart

      if (message != null) {
        NotificationService.instance.navigateFirebaseNotification(message);
      }
    });
    final user = context.read<AuthCubit>().state.user;
    final flow = context.read<FlowsCubit>();

    return BlocConsumer<ProfilesCubit, ProfilesState>(
      listener: (context, state) async {
        if (state is ProfilesExternalErrorState) {
          log(state.errorMessage);
          SnackBarHelper.showMessage(
            context,
            text: 'Cannot download profiles. Please try again later.',
            isError: true,
          );
        }
      },
      listenWhen: (previous, current) => current is ProfilesExternalErrorState,
      buildWhen: (previous, current) => true,
      builder: (context, state) {
        final gridItems = createGridItems(
          state.profiles.where((e) => e.type == 'Child').toList(),
          state.cachedMembers
              .where((element) => element.type == ProfileType.Child)
              .toList(),
          user,
        );
        return FunScaffold(
          appBar: const FunTopAppBar(
            title: 'Family',
          ),
          body: state is ProfilesLoadingState
              ? const CustomCircularProgressIndicator()
              : state.profiles.isEmpty && state.cachedMembers.isEmpty
                  ? ProfilesEmptyStateWidget(
                      onRetry: () =>
                          context.read<ProfilesCubit>().fetchAllProfiles(),
                    )
                  : Column(
                      children: [
                        if (!flow.state.isCoin)
                          Visibility(
                            child: ParentOverviewWidget(
                              profiles: sortedAdults(
                                user.guid,
                                state.profiles
                                    .where((p) => p.type == 'Parent')
                                    .toList(),
                              ),
                              cachedMembers: state.cachedMembers,
                            ),
                          ),
                        const SizedBox(height: 26),
                        if (gridItems.isNotEmpty)
                          Expanded(
                            child: GridView.count(
                              childAspectRatio: 0.74,
                              crossAxisCount:
                                  gridItems.length < 3 ? gridItems.length : 3,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              children: gridItems,
                            ),
                          ),
                        const SizedBox(height: 8),
                        if (state.profiles.length >= 2) ...[
                          FunButton(
                            onTap: () => context.goNamed(
                              FamilyPages.reflectIntro.name,
                            ),
                            text: 'Gratitude game',
                            analyticsEvent: AnalyticsEvent(
                              AmplitudeEvents.reflectAndShareClicked,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        FunButton.secondary(
                          onTap: () async {
                            if (!context.mounted) return;
                            flow.resetFlow();
                            await FamilyAuthUtils.authenticateUser(
                              context,
                              checkAuthRequest: CheckAuthRequest(
                                navigate: (context, {isUSUser}) async {
                                  await context.pushNamed(
                                    FamilyPages.childrenOverview.name,
                                  );
                                  _logUser(context, user);
                                },
                              ),
                            );
                          },
                          text: 'Manage Family',
                          leftIcon: FontAwesomeIcons.sliders,
                          analyticsEvent: AnalyticsEvent(
                            AmplitudeEvents.manageFamilyPressed,
                          ),
                        ),
                      ],
                    ),
        );
      },
    );
  }

  void _logUser(BuildContext context, UserExt user) {
    unawaited(
      AnalyticsHelper.setUserProperties(
        userId: user.guid,
        userProperties: AnalyticsHelper.getUserPropertiesFromExt(user),
      ),
    );
  }

  // The Givt user profile is first in the list
  static List<Profile> sortedAdults(
    String givtAccountID,
    List<Profile> adults,
  ) {
    return adults
      ..sort((a, b) {
        final compareNames = a.compareNames(b);
        return a.id == givtAccountID
            ? -1
            : b.id == givtAccountID
                ? 1
                : compareNames;
      });
  }

  List<Widget> createGridItems(
    List<Profile> profiles,
    List<Member> cachedChildren,
    UserExt user,
  ) {
    final gridItems = <Widget>[];
    for (var i = 0;
        i < cachedChildren.length &&
            i < ProfileSelectionScreen.maxVivibleProfiles;
        i++) {
      gridItems.add(
        ProfileItem(
          name: cachedChildren[i].firstName!,
          assetImage: 'assets/images/default_hero.svg',
        ),
      );
    }

    for (var i = 0;
        i < profiles.length &&
            i <
                ProfileSelectionScreen.maxVivibleProfiles -
                    cachedChildren.length;
        i++) {
      gridItems.add(
        GestureDetector(
          onTap: () {
            final flow = context.read<FlowsCubit>().state;
            final selectedProfile = profiles[i];
            context.read<ProfilesCubit>().setActiveProfile(selectedProfile.id);

            AnalyticsHelper.setUserProperties(
              userId: selectedProfile.id,
              userProperties: {
                if (selectedProfile.id == user.guid) 'email': user.email,
                'profile_country': user.country,
                'first_name': selectedProfile.firstName,
                AnalyticsHelper.isFamilyAppKey: true,
              },
            );
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.profilePressed,
              eventProperties: {
                'profile_name':
                    '${selectedProfile.firstName} ${selectedProfile.lastName}',
              },
            );

            if (flow.isQRCode) {
              context.goNamed(FamilyPages.camera.name);
              return;
            }
            if (flow.isRecommendation) {
              context.goNamed(FamilyPages.recommendationStart.name);
              return;
            }
            if (flow.flowType == FlowType.deepLinkCoin) {
              if (selectedProfile.wallet.balance < 1) {
                EmptyWalletBottomSheet.show(context);
                return;
              }
              context.pushNamed(FamilyPages.familyChooseAmountSlider.name);
              return;
            }
            if (flow.isCoin) {
              if (selectedProfile.wallet.balance < 1) {
                EmptyWalletBottomSheet.show(context);
                return;
              }
              context.goNamed(FamilyPages.scanNFC.name);
              return;
            }

            context.pushNamed(FamilyPages.wallet.name);
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

  void clearBottomsheet() {
    setState(() {
      isCachedMembersBottomsheetUp = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppThemeSwitcher.of(context).switchTheme(isFamilyApp: true);
    });
  }
}
