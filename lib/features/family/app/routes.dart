import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/app/pages.dart';
import 'package:givt_app/features/family/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app/features/family/features/avatars/screens/avatar_selection_screen.dart';
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
import 'package:givt_app/features/family/features/history/history_logic/history_cubit.dart';
import 'package:givt_app/features/family/features/history/history_screen.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/home_screen.dart';
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
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FamilyAppRoutes {
  static List<RouteBase> get routes => _routes;

  static final List<RouteBase> _routes = [
    // GoRoute(
    //   path: FamilyPages.profileSelection.path,
    //   name: FamilyPages.profileSelection.name,
    //   builder: (_, routerState) => MultiBlocProvider(
    //     providers: [
    //       BlocListener<AuthCubit, AuthState>(
    //         listener: (context, state) =>
    //             _checkAndRedirectAuth(state, context, routerState),
    //       ),
    //       BlocProvider<ProfilesCubit>(
    //         create: (BuildContext context) => ProfilesCubit(getIt()),
    //         lazy: true,
    //       ),
    //       BlocProvider<OrganisationDetailsCubit>(
    //         create: (BuildContext context) =>
    //             OrganisationDetailsCubit(getIt()),
    //         lazy: true,
    //       ),
    //       BlocProvider<FlowsCubit>(
    //         create: (BuildContext context) => FlowsCubit(),
    //       ),
    //       BlocProvider<FamilyImpactGroupsCubit.ImpactGroupsCubit>(
    //         create: (BuildContext context) =>
    //             FamilyImpactGroupsCubit.ImpactGroupsCubit(getIt()),
    //         lazy: true,
    //       ),
    //       BlocProvider(
    //         create: (context) => ScanNfcCubit(),
    //       ),
    //     ],
    //     child: Theme(
    //       data: const FamilyAppTheme().toThemeData(),
    //       child: const ProfileSelectionScreen(),
    //     ),
    //   ),
    //   routes: [
    //     GoRoute(
    //       path: FamilyPages.wallet.path,
    //       name: FamilyPages.wallet.name,
    //       builder: (context, state) {
    //         context.read<ProfilesCubit>().fetchActiveProfile();
    //         final user = context.read<ProfilesCubit>().state.activeProfile;
    //         context
    //             .read<FamilyImpactGroupsCubit.ImpactGroupsCubit>()
    //             .fetchImpactGroups(user.id, true);
    //         return MultiBlocProvider(
    //           providers: [
    //             BlocProvider(
    //               create: (context) => NavigationCubit(),
    //             ),
    //             BlocProvider(
    //               create: (context) =>
    //                   HistoryCubit(getIt())..fetchHistory(user.id),
    //             ),
    //           ],
    //           child: Theme(
    //             data: const FamilyAppTheme().toThemeData(),
    //             child: const HomeScreen(),
    //           ),
    //         );
    //       },
    //     ),
    //   ],
    // ),

    GoRoute(
      path: FamilyPages.profileSelection.path,
      name: FamilyPages.profileSelection.name,
      builder: (context, state) => const ProfileSelectionScreen(),
    ),
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
            child: Theme(
              data: const FamilyAppTheme().toThemeData(),
              child: const HomeScreen(),
            ),
          );
        }),
    GoRoute(
      path: FamilyPages.camera.path,
      name: FamilyPages.camera.name,
      builder: (context, state) => BlocProvider(
        create: (context) => CameraCubit()..checkPermission(),
        child: Theme(
          data: const FamilyAppTheme().toThemeData(),
          child: const CameraScreen(),
        ),
      ),
    ),
    GoRoute(
      path: FamilyPages.chooseAmountSlider.path,
      name: FamilyPages.chooseAmountSlider.name,
      builder: (context, state) => BlocProvider(
        create: (BuildContext context) =>
            CreateTransactionCubit(context.read<ProfilesCubit>(), getIt()),
        child: Theme(
          data: const FamilyAppTheme().toThemeData(),
          child: const ChooseAmountSliderScreen(),
        ),
      ),
    ),
    GoRoute(
        path: FamilyPages.chooseAmountSliderGoal.path,
        name: FamilyPages.chooseAmountSliderGoal.name,
        builder: (context, state) {
          final extra = state.extra ?? const Goal.empty();
          final group = extra as ImpactGroup;
          return BlocProvider(
            create: (BuildContext context) =>
                CreateTransactionCubit(context.read<ProfilesCubit>(), getIt()),
            child: Theme(
              data: const FamilyAppTheme().toThemeData(),
              child: ChooseAmountSliderGoalScreen(
                group: group,
              ),
            ),
          );
        }),
    GoRoute(
      path: FamilyPages.success.path,
      name: FamilyPages.success.name,
      builder: (context, state) => Theme(
        data: const FamilyAppTheme().toThemeData(),
        child: const SuccessScreen(),
      ),
    ),
    GoRoute(
      path: FamilyPages.history.path,
      name: FamilyPages.history.name,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: BlocProvider(
          create: (context) => HistoryCubit(getIt())
            ..fetchHistory(
                context.read<ProfilesCubit>().state.activeProfile.id),
          child: Theme(
            data: const FamilyAppTheme().toThemeData(),
            child: const HistoryScreen(),
          ),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: const Offset(2, 0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.ease)),
                ),
                child: child),
      ),
    ),
    GoRoute(
      path: FamilyPages.recommendationStart.path,
      name: FamilyPages.recommendationStart.name,
      builder: (context, state) => Theme(
        data: const FamilyAppTheme().toThemeData(),
        child: const StartRecommendationScreen(),
      ),
    ),
    GoRoute(
      path: FamilyPages.locationSelection.path,
      name: FamilyPages.locationSelection.name,
      builder: (context, state) => BlocProvider(
        create: (context) => TagsCubit(
          getIt(),
        )..fetchTags(),
        child: Theme(
          data: const FamilyAppTheme().toThemeData(),
          child: const LocationSelectionScreen(),
        ),
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
          child: Theme(
            data: const FamilyAppTheme().toThemeData(),
            child: const InterestsSelectionScreen(),
          ),
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
          child: Theme(
            data: const FamilyAppTheme().toThemeData(),
            child: const OrganisationsScreen(),
          ),
        );
      },
    ),
    GoRoute(
      path: FamilyPages.searchForCoin.path,
      name: FamilyPages.searchForCoin.name,
      redirect: (context, state) => getIt<SharedPreferences>()
                  .getBool('isInAppCoinFlow') ==
              true
          ? null
          : "${FamilyPages.outAppCoinFlow.path}?code=${state.uri.queryParameters['code']}",
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
          create: (BuildContext context) =>
              CreateTransactionCubit(context.read<ProfilesCubit>(), getIt()),
          child: Theme(
            data: const FamilyAppTheme().toThemeData(),
            child: const ChooseAmountSliderScreen(),
          ),
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
          child: Theme(
            data: const FamilyAppTheme().toThemeData(),
            child: const SearchForCoinScreen(),
          ),
        );
      },
    ),
    GoRoute(
      path: FamilyPages.scanNFC.path,
      name: FamilyPages.scanNFC.name,
      builder: (context, state) {
        return Theme(
          data: const FamilyAppTheme().toThemeData(),
          child: const NFCScanPage(),
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
        return Theme(
          data: const FamilyAppTheme().toThemeData(),
          child: SuccessCoinScreen(isGoal: isGoal),
        );
      },
    ),
    GoRoute(
      path: FamilyPages.avatarSelection.path,
      name: FamilyPages.avatarSelection.name,
      builder: (context, state) {
        final activeProfile = context.read<ProfilesCubit>().state.activeProfile;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AvatarsCubit(
                getIt(),
              )..fetchAvatars(),
            ),
            BlocProvider(
              create: (context) => EditProfileCubit(
                childGUID: activeProfile.id,
                editProfileRepository: getIt(),
                currentProfilePicture: activeProfile.pictureURL,
              ),
            ),
          ],
          child: Theme(
            data: const FamilyAppTheme().toThemeData(),
            child: const AvatarSelectionScreen(),
          ),
        );
      },
    ),
    GoRoute(
      path: FamilyPages.impactGroupDetails.path,
      name: FamilyPages.impactGroupDetails.name,
      builder: (context, state) {
        final impactGroup = state.extra! as ImpactGroup;
        return Theme(
          data: const FamilyAppTheme().toThemeData(),
          child: ImpactGroupDetailsPage(impactGroup: impactGroup),
        );
      },
    ),
  ];
}
