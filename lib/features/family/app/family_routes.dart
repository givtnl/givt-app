import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/details/cubit/child_details_cubit.dart';
import 'package:givt_app/features/children/details/pages/child_details_page.dart';
import 'package:givt_app/features/children/edit_child/cubit/edit_child_cubit.dart';
import 'package:givt_app/features/children/edit_child/pages/edit_child_page.dart';
import 'package:givt_app/features/children/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:givt_app/features/children/family_goal/cubit/create_family_goal_cubit.dart';
import 'package:givt_app/features/children/family_goal/pages/create_family_goal_flow_page.dart';
import 'package:givt_app/features/children/family_history/family_history_cubit/family_history_cubit.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app/features/family/features/avatars/screens/kids_avatar_selection_screen.dart';
import 'package:givt_app/features/family/features/avatars/screens/parent_avatar_selection_screen.dart';
import 'package:givt_app/features/family/features/coin_flow/cubit/search_coin_cubit.dart';
import 'package:givt_app/features/family/features/coin_flow/screens/search_for_coin_screen.dart';
import 'package:givt_app/features/family/features/coin_flow/screens/success_coin_screen.dart';
import 'package:givt_app/features/family/features/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/collectgroup_details/cubit/collectgroup_details_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/screens/choose_amount_slider_goal_screen.dart';
import 'package:givt_app/features/family/features/giving_flow/screens/choose_amount_slider_screen.dart';
import 'package:givt_app/features/family/features/giving_flow/screens/success_screen.dart';
import 'package:givt_app/features/family/features/history/history_cubit/history_cubit.dart';
import 'package:givt_app/features/family/features/history/history_screen.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/pages/kids_home_screen.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/pages/navigation_bar_home_screen.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/pages/parent_home_screen.dart';
import 'package:givt_app/features/family/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/features/family/features/impact_groups/model/goal.dart';
import 'package:givt_app/features/family/features/impact_groups/model/impact_group.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/pages/give_from_list_page.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/pages/parent_giving_page.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/qr_scanner/cubit/camera_cubit.dart';
import 'package:givt_app/features/family/features/qr_scanner/presentation/camera_screen.dart';
import 'package:givt_app/features/family/features/recommendation/interests/cubit/interests_cubit.dart';
import 'package:givt_app/features/family/features/recommendation/interests/screens/interests_selection_screen.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/cubit/organisations_cubit.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/screens/organisations_screen.dart';
import 'package:givt_app/features/family/features/recommendation/start_recommendation/start_recommendation_screen.dart';
import 'package:givt_app/features/family/features/recommendation/tags/cubit/tags_cubit.dart';
import 'package:givt_app/features/family/features/recommendation/tags/screens/location_selection_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/reflect_intro_screen.dart';
import 'package:givt_app/features/family/features/scan_nfc/nfc_scan_screen.dart';
import 'package:givt_app/features/permit_biometric/cubit/permit_biometric_cubit.dart';
import 'package:givt_app/features/permit_biometric/models/permit_biometric_request.dart';
import 'package:givt_app/features/permit_biometric/pages/permit_biometric_page.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/features/registration/pages/credit_card_details_page.dart';
import 'package:givt_app/features/registration/pages/registration_success_us.dart';
import 'package:givt_app/features/registration/pages/us_signup_page.dart';
import 'package:givt_app/features/unregister_account/cubit/unregister_cubit.dart';
import 'package:givt_app/features/unregister_account/unregister_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/organisation/organisation.dart';
import 'package:givt_app/shared/bloc/remote_data_source_sync/remote_data_source_sync_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FamilyAppRoutes {
  static List<RouteBase> get routes => _routes;

  static final List<RouteBase> _routes = [
    GoRoute(
      path: FamilyPages.profileSelection.path,
      name: FamilyPages.profileSelection.name,
      builder: (context, state) {
        final index = int.tryParse(state.uri.queryParameters['index'] ?? '');
        final showAllowanceWarning = bool.tryParse(
            state.uri.queryParameters['showAllowanceWarning'] ?? '');
        return MultiBlocProvider(
          providers: [
            // profile selection (home screen, for now)
            BlocProvider(
              lazy: false,
              create: (_) => RemoteDataSourceSyncBloc(
                getIt(),
                getIt(),
              )..add(const RemoteDataSourceSyncRequested()),
            ),
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
            // manage family
            BlocProvider(
              create: (_) => FamilyOverviewCubit(getIt())
                ..fetchFamilyProfiles(
                  showAllowanceWarning: showAllowanceWarning ?? false,
                ),
            ),
            BlocProvider(
              create: (context) =>
                  FamilyHistoryCubit(getIt(), getIt(), getIt())..fetchHistory(),
            ),
            // us personal info edit page
            BlocProvider(
              create: (context) => PersonalInfoEditBloc(
                loggedInUserExt: context.read<AuthCubit>().state.user,
                authRepositoy: getIt(),
              ),
            ),
          ],
          child: NavigationBarHomeScreen(
            index: index,
          ),
        );
      },
      routes: [
        GoRoute(
          path: FamilyPages.parentHome.path,
          name: FamilyPages.parentHome.name,
          builder: (context, state) {
            final extra = state.extra! as Profile;
            return ParentHomeScreen(
              profile: extra,
            );
          },
        ),
        GoRoute(
          path: FamilyPages.giveByListFamily.path,
          name: FamilyPages.giveByListFamily.name,
          builder: (context, state) {
            final user = context.read<AuthCubit>().state.user;
            return MultiBlocProvider(
              providers: [
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
              ],
              child: const GiveFromListPage(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.parentGive.path,
          name: FamilyPages.parentGive.name,
          builder: (context, state) => const ParentGivingPage(),
        ),
        GoRoute(
          path: FamilyPages.wallet.path,
          name: FamilyPages.wallet.name,
          builder: (context, state) {
            return const KidsHomeScreen();
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
                context.read<ProfilesCubit>(),
                getIt(),
              ),
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
            final mediumID = state.uri.queryParameters['code'] == null ||
                    state.uri.queryParameters['code']!.contains('null')
                ? CollectGroupDetailsCubit.defaultMediumId
                : state.uri.queryParameters['code']!;
            // THE USECASE FOR THIS BUILDER IS
            // When the user opens the app from in-app coin flow
            // on andrioid accidentally scanning the coin twice

            // So the flow we need to show is in-app coin flow

            // Because the deeplink opens a whole new app context we need to
            // re-fetch the organisation details
            // & emit the in-app coin flow

            context
                .read<CollectGroupDetailsCubit>()
                .getOrganisationDetails(mediumID);

            context.read<FlowsCubit>().startInAppCoinFlow();

            return BlocProvider(
              create: (BuildContext context) => CreateTransactionCubit(
                context.read<ProfilesCubit>(),
                getIt(),
              ),
              child: const ChooseAmountSliderScreen(),
            );
          },
        ),
        GoRoute(
          path: FamilyPages.outAppCoinFlow.path,
          name: FamilyPages.outAppCoinFlow.name,
          builder: (context, state) {
            final mediumID = state.uri.queryParameters['code']!.contains('null')
                ? CollectGroupDetailsCubit.defaultMediumId
                : state.uri.queryParameters['code']!;

            context
                .read<CollectGroupDetailsCubit>()
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
          redirect: (context, state) {
            return '${FamilyPages.profileSelection.path}?index=${NavigationBarHomeScreen.profileIndex}';
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
          path: FamilyPages.childrenOverview.path,
          name: FamilyPages.childrenOverview.name,
          redirect: (context, state) {
            var showAllowanceWarning = false;
            if (state.extra != null) {
              showAllowanceWarning = state.extra!.toString().contains('true');
            }
            final user = context.read<ProfilesCubit>().state.activeProfile;
            context.read<ImpactGroupsCubit>().fetchImpactGroups(user.id, true);
            return '${FamilyPages.profileSelection.path}?index=${NavigationBarHomeScreen.familyIndex}&showAllowanceWarning=$showAllowanceWarning';
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
              child: UsSignUpPage(
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
        GoRoute(
          path: FamilyPages.reflectIntro.path,
          name: FamilyPages.reflectIntro.name,
          builder: (context, state) => const ReflectIntroScreen(),
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
