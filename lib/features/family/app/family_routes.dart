import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/pages/member_main_scaffold_page.dart';
import 'package:givt_app/features/children/cached_members/cubit/cached_members_cubit.dart';
import 'package:givt_app/features/children/cached_members/pages/cached_family_overview_page.dart';
import 'package:givt_app/features/children/details/cubit/child_details_cubit.dart';
import 'package:givt_app/features/children/details/pages/child_details_page.dart';
import 'package:givt_app/features/children/edit_child/cubit/edit_child_cubit.dart';
import 'package:givt_app/features/children/edit_child/pages/edit_child_page.dart';
import 'package:givt_app/features/children/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:givt_app/features/children/family_goal/cubit/create_family_goal_cubit.dart';
import 'package:givt_app/features/children/family_goal/pages/create_family_goal_flow_page.dart';
import 'package:givt_app/features/children/family_history/family_history_cubit/family_history_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/create_challenge_donation/cubit/create_challenge_donation_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/create_challenge_donation/pages/choose_amount_slider_page.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/day4_timer/pages/day4_timer_screen.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/cubit/family_values_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/pages/display_family_values_page.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/pages/display_organisations_page.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/pages/select_family_values_page.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/set_up_allowance/generosity_allowance_flow_page.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/pages/generosity_challenge.dart';
import 'package:givt_app/features/children/generosity_challenge/pages/generosity_challenge_introduction.dart';
import 'package:givt_app/features/children/generosity_challenge/pages/registration_redirect_to_generosity_screen.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/cubit/chat_scripts_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/pages/chat_script_page.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/features/children/overview/pages/family_overview_page.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/account/presentation/pages/us_personal_info_edit_page.dart';
import 'package:givt_app/features/family/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app/features/family/features/avatars/screens/kids_avatar_selection_screen.dart';
import 'package:givt_app/features/family/features/avatars/screens/parent_avatar_selection_screen.dart';
import 'package:givt_app/features/family/features/coin_flow/cubit/search_coin_cubit.dart';
import 'package:givt_app/features/family/features/coin_flow/screens/search_for_coin_screen.dart';
import 'package:givt_app/features/family/features/coin_flow/screens/success_coin_screen.dart';
import 'package:givt_app/features/family/features/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/screens/choose_amount_slider_goal_screen.dart';
import 'package:givt_app/features/family/features/giving_flow/screens/choose_amount_slider_screen.dart';
import 'package:givt_app/features/family/features/giving_flow/screens/success_screen.dart';
import 'package:givt_app/features/family/features/history/history_cubit/history_cubit.dart';
import 'package:givt_app/features/family/features/history/history_screen.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/kids_home_screen.dart';
import 'package:givt_app/features/family/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/features/family/features/impact_groups/model/goal.dart';
import 'package:givt_app/features/family/features/impact_groups/model/impact_group.dart';
import 'package:givt_app/features/family/features/impact_groups/pages/impact_group_details_page.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/screens/profile_selection_screen.dart';
import 'package:givt_app/features/family/features/qr_scanner/cubit/camera_cubit.dart';
import 'package:givt_app/features/family/features/qr_scanner/presentation/camera_screen.dart';
import 'package:givt_app/features/family/features/recommendation/interests/cubit/interests_cubit.dart';
import 'package:givt_app/features/family/features/recommendation/interests/screens/interests_selection_screen.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/cubit/organisations_cubit.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/screens/organisations_screen.dart';
import 'package:givt_app/features/family/features/recommendation/start_recommendation/start_recommendation_screen.dart';
import 'package:givt_app/features/family/features/recommendation/tags/cubit/tags_cubit.dart';
import 'package:givt_app/features/family/features/recommendation/tags/screens/location_selection_screen.dart';
import 'package:givt_app/features/family/features/scan_nfc/nfc_scan_screen.dart';
import 'package:givt_app/features/give/bloc/give/give_bloc.dart';
import 'package:givt_app/features/give/bloc/organisation/organisation_bloc.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/features/permit_biometric/cubit/permit_biometric_cubit.dart';
import 'package:givt_app/features/permit_biometric/models/permit_biometric_request.dart';
import 'package:givt_app/features/permit_biometric/pages/permit_biometric_page.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/features/registration/pages/credit_card_details_page.dart';
import 'package:givt_app/features/registration/pages/registration_success_us.dart';
import 'package:givt_app/features/registration/pages/signup_page.dart';
import 'package:givt_app/features/unregister_account/cubit/unregister_cubit.dart';
import 'package:givt_app/features/unregister_account/unregister_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/remote_data_source_sync/remote_data_source_sync_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FamilyAppRoutes {
  static List<RouteBase> get routes => _routes;

  static final List<RouteBase> _routes = [
    GoRoute(
      path: FamilyPages.generosityChallengeRedirect.path,
      name: FamilyPages.generosityChallengeRedirect.name,
      builder: (context, state) =>
          const RegistrationRedirectToGenerosityScreen(),
    ),
    GoRoute(
      path: FamilyPages.generosityChallenge.path,
      name: FamilyPages.generosityChallenge.name,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => GenerosityChallengeCubit(
            getIt(),
            getIt(),
            getIt(),
          )..loadFromCache(),
          child: const GenerosityChallenge(),
        );
      },
      routes: [
        GoRoute(
          path: FamilyPages.day4Timer.path,
          name: FamilyPages.day4Timer.name,
          builder: (context, state) {
            final challengeCubit = state.extra! as GenerosityChallengeCubit;
            return BlocProvider.value(
              value: challengeCubit,
              child: const Day4TimerScreen(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.generosityChallengeIntroduction.path,
          name: FamilyPages.generosityChallengeIntroduction.name,
          builder: (context, state) {
            final challengeCubit = state.extra! as GenerosityChallengeCubit;
            return BlocProvider.value(
              value: challengeCubit,
              child: const PopScope(
                canPop: false,
                child: GenerosityChallengeIntroduction(),
              ),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.generosityChallengeChat.path,
          name: FamilyPages.generosityChallengeChat.name,
          builder: (context, state) {
            final challengeCubit = state.extra! as GenerosityChallengeCubit;
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: challengeCubit,
                ),
                BlocProvider(
                  create: (_) => ChatScriptsCubit(
                    getIt(),
                    challengeCubit: challengeCubit,
                  )..init(context),
                ),
              ],
              child: const ChatScriptPage(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.selectValues.path,
          name: FamilyPages.selectValues.name,
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: state.extra! as GenerosityChallengeCubit,
                ),
                BlocProvider(
                  create: (context) => FamilyValuesCubit(
                    generosityChallengeRepository: getIt(),
                  ),
                ),
              ],
              child: const SelectFamilyValues(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.displayValues.path,
          name: FamilyPages.displayValues.name,
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: state.extra! as GenerosityChallengeCubit,
                ),
                BlocProvider(
                  create: (context) => FamilyValuesCubit(
                    generosityChallengeRepository: getIt(),
                  )..getSavedValues(),
                ),
              ],
              child: const DisplayFamilyValues(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.displayValuesOrganisations.path,
          name: FamilyPages.displayValuesOrganisations.name,
          builder: (context, state) {
            final extra = state.extra! as Map<String, dynamic>;
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: extra[GenerosityChallengeHelper.generosityChallengeKey]
                      as GenerosityChallengeCubit,
                ),
              ],
              child: DisplayOrganisations(
                familyValues: extra[FamilyValuesCubit.familyValuesKey]
                    as List<FamilyValue>,
              ),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.chooseAmountSlider.path,
          name: FamilyPages.chooseAmountSlider.name,
          builder: (context, state) {
            final extras = state.extra! as List;
            final organisation = extras[0] as Organisation;
            final challengeCubit = extras[1] as GenerosityChallengeCubit;

            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => GiveBloc(
                    getIt(),
                    getIt(),
                    getIt(),
                    getIt(),
                  ),
                ),
                BlocProvider(
                  create: (context) => CreateChallengeDonationCubit(),
                ),
                BlocProvider.value(
                  value: challengeCubit,
                ),
              ],
              child: ChooseAmountSliderPage(
                organisation: organisation,
              ),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.allowanceFlow.path,
          name: FamilyPages.allowanceFlow.name,
          builder: (context, state) => BlocProvider.value(
            value: state.extra! as GenerosityChallengeCubit,
            child: const GenerosityAllowanceFlowPage(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: FamilyPages.profileSelection.path,
      name: FamilyPages.profileSelection.name,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (_) => RemoteDataSourceSyncBloc(
              getIt(),
              getIt(),
            )..add(const RemoteDataSourceSyncRequested()),
          ),
        ],
        child: const ProfileSelectionScreen(),
      ),
      routes: [
        GoRoute(
          path: FamilyPages.wallet.path,
          name: FamilyPages.wallet.name,
          builder: (context, state) {
            context.read<ProfilesCubit>().fetchActiveProfile();
            final user = context.read<ProfilesCubit>().state.activeProfile;
            context.read<ImpactGroupsCubit>().fetchImpactGroups(user.id, true);
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => NavigationCubit(),
                ),
                BlocProvider(
                  create: (context) =>
                      HistoryCubit(getIt())..fetchHistory(user.id),
                ),
              ],
              child: const KidsHomeScreen(),
            );
          },
          routes: [
            GoRoute(
              path: FamilyPages.scanNFC.path,
              name: FamilyPages.scanNFC.name,
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final isFromGenerosityChallenge =
                    extra?['isGenerosityChallenge'] as bool? ?? false;
                return NFCScanPage(
                  isFromGenerosityChallenge: isFromGenerosityChallenge,
                );
              },
            ),
            GoRoute(
              path: FamilyPages.recommendationStart.path,
              name: FamilyPages.recommendationStart.name,
              builder: (context, state) => const StartRecommendationScreen(),
            ),
            GoRoute(
              path: FamilyPages.camera.path,
              name: FamilyPages.camera.name,
              builder: (context, state) => BlocProvider(
                create: (context) => CameraCubit()..checkCameraPermission(),
                child: const CameraScreen(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: FamilyPages.familyChooseAmountSlider.path,
          name: FamilyPages.familyChooseAmountSlider.name,
          builder: (context, state) => BlocProvider(
            create: (BuildContext context) =>
                CreateTransactionCubit(context.read<ProfilesCubit>(), getIt()),
            child: const ChooseAmountSliderScreen(),
          ),
        ),
        GoRoute(
          path: FamilyPages.chooseAmountSliderGoal.path,
          name: FamilyPages.chooseAmountSliderGoal.name,
          builder: (context, state) {
            final extra = state.extra ?? const Goal.empty();
            final group = extra as ImpactGroup;
            return BlocProvider(
              create: (BuildContext context) => CreateTransactionCubit(
                  context.read<ProfilesCubit>(), getIt()),
              child: ChooseAmountSliderGoalScreen(
                group: group,
              ),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.success.path,
          name: FamilyPages.success.name,
          builder: (context, state) => const SuccessScreen(),
        ),
        GoRoute(
          path: FamilyPages.history.path,
          name: FamilyPages.history.name,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: BlocProvider(
              create: (context) => HistoryCubit(getIt())
                ..fetchHistory(
                  context.read<ProfilesCubit>().state.activeProfile.id,
                ),
              child: const HistoryScreen(),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(2, 0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.ease)),
              ),
              child: child,
            ),
          ),
        ),
        GoRoute(
          path: FamilyPages.locationSelection.path,
          name: FamilyPages.locationSelection.name,
          builder: (context, state) => BlocProvider(
            create: (context) => TagsCubit(
              getIt(),
            )..fetchTags(),
            child: const LocationSelectionScreen(),
          ),
        ),
        GoRoute(
          path: FamilyPages.interestsSelection.path,
          name: FamilyPages.interestsSelection.name,
          builder: (context, state) {
            final extra = state.extra ?? TagsStateFetched.empty();
            final tagsState = extra as TagsStateFetched;
            return BlocProvider(
              create: (context) => InterestsCubit(
                location: tagsState.selectedLocation,
                cityName: tagsState.selectedCity,
                interests: tagsState.interests,
              ),
              child: const InterestsSelectionScreen(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.recommendedOrganisations.path,
          name: FamilyPages.recommendedOrganisations.name,
          builder: (context, state) {
            final extra = state.extra ?? InterestsState.empty();
            final interestsState = extra as InterestsState;
            return BlocProvider(
              create: (context) => OrganisationsCubit(
                getIt(),
              )..getRecommendedOrganisations(
                  location: interestsState.location,
                  cityName: interestsState.cityName,
                  interests: interestsState.selectedInterests,
                  fakeComputingExtraDelay: const Duration(seconds: 1),
                ),
              child: const OrganisationsScreen(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.searchForCoin.path,
          name: FamilyPages.searchForCoin.name,
          redirect: (context, state) {
            return getIt<SharedPreferences>().getBool('isInAppCoinFlow') == true
                ? null
                : "${FamilyPages.profileSelection.path}/${FamilyPages.outAppCoinFlow.path}?code=${state.uri.queryParameters['code']}";
          },
          builder: (context, state) {
            final String mediumID = state.uri.queryParameters['code'] == null ||
                    state.uri.queryParameters['code']!.contains('null')
                ? OrganisationDetailsCubit.defaultMediumId
                : state.uri.queryParameters['code']!;
            // THE USECASE FOR THIS BUILDER IS
            // When the user opens the app from in-app coin flow
            // on andrioid accidentally scanning the coin twice

            // So the flow we need to show is in-app coin flow

            // Because the deeplink opens a whole new app context we need to
            // re-fetch the organisation details
            // & emit the in-app coin flow

            context
                .read<OrganisationDetailsCubit>()
                .getOrganisationDetails(mediumID);

            context.read<FlowsCubit>().startInAppCoinFlow();

            return BlocProvider(
              create: (BuildContext context) => CreateTransactionCubit(
                  context.read<ProfilesCubit>(), getIt()),
              child: const ChooseAmountSliderScreen(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.outAppCoinFlow.path,
          name: FamilyPages.outAppCoinFlow.name,
          builder: (context, state) {
            final mediumID = state.uri.queryParameters['code']!.contains('null')
                ? OrganisationDetailsCubit.defaultMediumId
                : state.uri.queryParameters['code']!;

            context
                .read<OrganisationDetailsCubit>()
                .getOrganisationDetails(mediumID);
            return BlocProvider<SearchCoinCubit>(
              lazy: false,
              create: (context) => SearchCoinCubit()..startAnimation(mediumID),
              child: const SearchForCoinScreen(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.successCoin.path,
          name: FamilyPages.successCoin.name,
          builder: (context, state) {
            final extra = state.extra ?? false;
            final isGoal = extra as bool;
            log('isGoal: $isGoal');
            return SuccessCoinScreen(isGoal: isGoal);
          },
        ),
        GoRoute(
          path: FamilyPages.parentAvatarSelection.path,
          name: FamilyPages.parentAvatarSelection.name,
          builder: (context, state) {
            final user = context.read<AuthCubit>().state.user;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => AvatarsCubit(
                    getIt(),
                  )..fetchAvatars(),
                ),
                BlocProvider(
                  create: (context) => EditProfileCubit(
                    editProfileRepository: getIt(),
                    currentProfilePicture: user.profilePicture,
                  ),
                ),
              ],
              child: const ParentAvatarSelectionScreen(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.kidsAvatarSelection.path,
          name: FamilyPages.kidsAvatarSelection.name,
          builder: (context, state) {
            final activeProfile =
                context.read<ProfilesCubit>().state.activeProfile;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => AvatarsCubit(
                    getIt(),
                  )..fetchAvatars(),
                ),
                BlocProvider(
                  create: (context) => EditChildProfileCubit(
                    childGUID: activeProfile.id,
                    editProfileRepository: getIt(),
                    currentProfilePicture: activeProfile.pictureURL,
                  ),
                ),
              ],
              child: const KidsAvatarSelectionScreen(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.impactGroupDetails.path,
          name: FamilyPages.impactGroupDetails.name,
          builder: (context, state) {
            final impactGroup = state.extra! as ImpactGroup;
            return ImpactGroupDetailsPage(impactGroup: impactGroup);
          },
        ),
        GoRoute(
          path: FamilyPages.unregisterUS.path,
          name: FamilyPages.unregisterUS.name,
          builder: (_, state) => BlocProvider(
            create: (_) => UnregisterCubit(
              getIt(),
            ),
            child: const UnregisterPage(),
          ),
        ),
        GoRoute(
          path: FamilyPages.creditCardDetails.path,
          name: FamilyPages.creditCardDetails.name,
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: state.extra! as RegistrationBloc,
                ),
                BlocProvider(
                  create: (_) => StripeCubit(
                    authRepositoy: getIt(),
                  ),
                ),
              ],
              child: const CreditCardDetailsPage(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.registrationSuccessUs.path,
          name: FamilyPages.registrationSuccessUs.name,
          builder: (_, state) => const RegistrationSuccessUs(),
        ),
        GoRoute(
          path: FamilyPages.familyPersonalInfoEdit.path,
          name: FamilyPages.familyPersonalInfoEdit.name,
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => PersonalInfoEditBloc(
                    loggedInUserExt: context.read<AuthCubit>().state.user,
                    authRepositoy: getIt(),
                  ),
                ),
                BlocProvider(
                  create: (context) => StripeCubit(
                    authRepositoy: getIt(),
                  ),
                ),
              ],
              child: const USPersonalInfoEditPage(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.createFamilyGoal.path,
          name: FamilyPages.createFamilyGoal.name,
          builder: (context, state) {
            final user = context.read<AuthCubit>().state.user;
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: state.extra! as FamilyOverviewCubit,
                ),
                BlocProvider(
                  create: (_) => OrganisationBloc(
                    getIt(),
                    getIt(),
                  )..add(
                      OrganisationFetch(
                        Country.fromCode(user.country),
                        type: CollectGroupType.none.index,
                      ),
                    ),
                ),
                BlocProvider(
                  create: (_) => CreateFamilyGoalCubit(getIt()),
                ),
              ],
              child: const CreateFamilyGoalFlowPage(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.cachedChildrenOverview.path,
          name: FamilyPages.cachedChildrenOverview.name,
          builder: (context, state) => BlocProvider(
            create: (_) => CachedMembersCubit(
              getIt(),
              getIt(),
              familyLeaderName: context.read<AuthCubit>().state.user.firstName,
            )..loadFromCache(),
            child: const CachedFamilyOverviewPage(),
          ),
        ),
        GoRoute(
          path: FamilyPages.childDetails.path,
          name: FamilyPages.childDetails.name,
          builder: (context, state) {
            final extras = state.extra! as List<dynamic>;
            final childrenOverviewCubit = extras[0] as FamilyOverviewCubit;
            final childProfile = extras[1] as Profile;
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: childrenOverviewCubit,
                ),
                BlocProvider(
                  create: (_) => ChildDetailsCubit(
                    getIt(),
                    getIt(),
                    getIt(),
                    childProfile,
                  )..fetchChildDetails(),
                ),
              ],
              child: const ChildDetailsPage(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.editChild.path,
          name: FamilyPages.editChild.name,
          builder: (context, state) {
            final extras = state.extra! as List<dynamic>;
            final childrenOverviewCubit = extras[0] as FamilyOverviewCubit;
            final childDetailsCubit = extras[1] as ChildDetailsCubit;
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: childDetailsCubit,
                ),
                BlocProvider.value(
                  value: childrenOverviewCubit,
                ),
                BlocProvider(
                  create: (_) => EditChildCubit(
                    getIt(),
                    AppLocalizations.of(context),
                    (childDetailsCubit.state as ChildDetailsFetchedState)
                        .profileDetails,
                  ),
                ),
              ],
              child: const EditChildPage(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.addMember.path,
          name: FamilyPages.addMember.name,
          builder: (context, state) {
            final familyAlreadyExists = state.extra as bool? ?? false;
            return BlocProvider(
              create: (_) => AddMemberCubit(getIt(), getIt()),
              child: AddMemberMainScaffold(
                familyAlreadyExists: familyAlreadyExists,
              ),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.childrenOverview.path,
          name: FamilyPages.childrenOverview.name,
          builder: (context, state) {
            var showAllowanceWarning = false;
            if (state.extra != null) {
              showAllowanceWarning = state.extra!.toString().contains('true');
            }
            context.read<ProfilesCubit>().fetchActiveProfile();
            final user = context.read<ProfilesCubit>().state.activeProfile;
            context.read<ImpactGroupsCubit>().fetchImpactGroups(user.id, true);
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => FamilyOverviewCubit(getIt())
                    ..fetchFamilyProfiles(
                      showAllowanceWarning: showAllowanceWarning,
                    ),
                ),
                BlocProvider(
                  create: (context) =>
                      FamilyHistoryCubit(getIt(), getIt())..fetchHistory(),
                ),
              ],
              child: const FamilyOverviewPage(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.registrationUS.path,
          name: FamilyPages.registrationUS.name,
          builder: (context, state) {
            final email = state.uri.queryParameters['email'] ?? '';

            final createStripe = bool.parse(
              state.uri.queryParameters['createStripe'] ?? 'false',
            );

            if (createStripe) {
              context
                  .read<RegistrationBloc>()
                  .add(const RegistrationStripeInit());
            }

            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => StripeCubit(
                    authRepositoy: getIt(),
                  ),
                ),
              ],
              child: SignUpPage(
                email: email,
              ),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.permitUSBiometric.path,
          name: FamilyPages.permitUSBiometric.name,
          builder: (context, state) {
            final permitBiometricRequest =
                state.extra! as PermitBiometricRequest;
            return BlocProvider(
              create: (_) => PermitBiometricCubit(
                permitBiometricRequest: permitBiometricRequest,
              )..checkBiometric(),
              child: const PermitBiometricPage(),
            );
          },
        ),
      ],
      redirect: (context, state) {
        final page = state.uri.queryParameters['page'];
        if (true == page?.isNotEmpty) {
          return '${FamilyPages.profileSelection.path}/$page';
        } else {
          return null;
        }
      },
    ),
  ];
}
