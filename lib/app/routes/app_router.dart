import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/account_details/pages/personal_info_edit_page.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/pages/member_main_scaffold_page.dart';
import 'package:givt_app/features/children/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app/features/children/avatars/screens/avatar_selection_screen.dart';
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
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/cubit/family_values_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/pages/display_family_values_page.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/pages/display_organisations_page.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/pages/select_family_values_page.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/set_up_allowance/generosity_allowance_flow_page.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/pages/generosity_challenge.dart';
import 'package:givt_app/features/children/generosity_challenge/pages/generosity_challenge_introduction.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/cubit/chat_scripts_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/pages/chat_script_page.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/features/children/overview/pages/family_overview_page.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app/features/family/features/history/history_logic/history_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/home_screen.dart';
import 'package:givt_app/features/family/features/impact_groups/cubit/impact_groups_cubit.dart'
    as FamilyImpactGroupsCubit;
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/screens/profile_selection_screen.dart';
import 'package:givt_app/features/family/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app/features/family/utils/app_theme.dart';
import 'package:givt_app/features/first_use/pages/welcome_page.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/features/give/pages/bt_scan_page.dart';
import 'package:givt_app/features/give/pages/giving_page.dart';
import 'package:givt_app/features/give/pages/gps_scan_page.dart';
import 'package:givt_app/features/give/pages/home_page.dart';
import 'package:givt_app/features/give/pages/organization_list_page.dart';
import 'package:givt_app/features/give/pages/qr_code_scan_page.dart';
import 'package:givt_app/features/give/pages/select_giving_way_page.dart';
import 'package:givt_app/features/give/pages/success_donation_page.dart';
import 'package:givt_app/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/impact_groups/pages/impact_group_details_page.dart';
import 'package:givt_app/features/impact_groups/pages/impact_group_join_success_page.dart';
import 'package:givt_app/features/overview/bloc/givt_bloc.dart';
import 'package:givt_app/features/overview/pages/overview_page.dart';
import 'package:givt_app/features/permit_biometric/cubit/permit_biometric_cubit.dart';
import 'package:givt_app/features/permit_biometric/models/permit_biometric_request.dart';
import 'package:givt_app/features/permit_biometric/pages/permit_biometric_page.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/cubit/add_external_donation_cubit.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/pages/add_external_donation_page.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/features/personal_summary/overview/pages/personal_summary_page.dart';
import 'package:givt_app/features/personal_summary/yearly_overview/cubit/yearly_overview_cubit.dart';
import 'package:givt_app/features/personal_summary/yearly_overview/pages/yearly_overview_page.dart';
import 'package:givt_app/features/recurring_donations/overview/cubit/recurring_donations_cubit.dart';
import 'package:givt_app/features/recurring_donations/overview/pages/recurring_donations_overview_page.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/features/registration/pages/credit_card_details_page.dart';
import 'package:givt_app/features/registration/pages/pages.dart';
import 'package:givt_app/features/registration/pages/registration_success_us.dart';
import 'package:givt_app/features/unregister_account/cubit/unregister_cubit.dart';
import 'package:givt_app/features/unregister_account/unregister_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/remote_data_source_sync/remote_data_source_sync_bloc.dart';
import 'package:givt_app/shared/pages/pages.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/',
        name: 'custom_url',
        redirect: _redirectFromExternalLink,
      ),
      GoRoute(
        path: '/givt',
        name: 'givt',
        redirect: _redirectFromExternalLink,
      ),
      GoRoute(
        path: '/download',
        name: 'download',
        redirect: _redirectFromExternalLink,
      ),
      GoRoute(
        path: Pages.splash.path,
        name: Pages.splash.name,
        builder: (context, routerState) => BlocListener<AuthCubit, AuthState>(
          listener: (context, state) =>
              _checkAndRedirectAuth(state, context, routerState),
          child: const SplashPage(),
        ),
      ),
      GoRoute(
        path: Pages.loading.path,
        name: Pages.loading.name,
        builder: (context, routerState) => BlocListener<AuthCubit, AuthState>(
          listener: (context, state) =>
              _checkAndRedirectAuth(state, context, routerState),
          child: const LoadingPage(),
        ),
      ),
      GoRoute(
        path: Pages.generosityChallenge.path,
        name: Pages.generosityChallenge.name,
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
            path: Pages.generosityChallengeIntroduction.path,
            name: Pages.generosityChallengeIntroduction.name,
            builder: (context, state) {
              final challengeCubit = state.extra! as GenerosityChallengeCubit;
              return BlocProvider.value(
                value: challengeCubit,
                child: const GenerosityChallengeIntruduction(),
              );
            },
          ),
          GoRoute(
            path: Pages.generosityChallengeChat.path,
            name: Pages.generosityChallengeChat.name,
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
            path: Pages.selectValues.path,
            name: Pages.selectValues.name,
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
            path: Pages.displayValues.path,
            name: Pages.displayValues.name,
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
            path: Pages.displayValuesOrganisations.path,
            name: Pages.displayValuesOrganisations.name,
            builder: (context, state) {
              final extra = state.extra! as Map<String, dynamic>;
              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value:
                        extra[GenerosityChallengeHelper.generosityChallengeKey]
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
            path: Pages.chooseAmountSlider.path,
            name: Pages.chooseAmountSlider.name,
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
            path: Pages.allowanceFlow.path,
            name: Pages.allowanceFlow.name,
            builder: (context, state) => BlocProvider.value(
              value: state.extra! as GenerosityChallengeCubit,
              child: const GenerosityAllowanceFlowPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: Pages.home.path,
        name: Pages.home.name,
        routes: [
          GoRoute(
            path: Pages.personalSummary.path,
            name: Pages.personalSummary.name,
            builder: (context, state) => BlocProvider(
              create: (_) => PersonalSummaryBloc(
                loggedInUserExt: context.read<AuthCubit>().state.user,
                givingGoalRepository: getIt(),
                givtRepo: getIt(),
              )..add(
                  const PersonalSummaryInit(),
                ),
              child: const PersonalSummary(),
            ),
            routes: [
              GoRoute(
                path: Pages.addExternalDonation.path,
                name: Pages.addExternalDonation.name,
                builder: (context, state) {
                  final summaryBloc = state.extra! as PersonalSummaryBloc;
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: summaryBloc,
                      ),
                      BlocProvider(
                        create: (context) => AddExternalDonationCubit(
                          dateTime: summaryBloc.state.dateTime,
                          givtRepository: getIt(),
                        )..init(),
                      ),
                    ],
                    child: const AddExternalDonationPage(),
                  );
                },
              ),
              GoRoute(
                path: Pages.yearlyOverview.path,
                name: Pages.yearlyOverview.name,
                builder: (context, state) {
                  final guid = context.read<AuthCubit>().state.user.guid;
                  final summaryBloc = state.extra! as PersonalSummaryBloc;
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: summaryBloc,
                      ),
                      BlocProvider(
                        create: (context) => YearlyOverviewCubit(
                          getIt(),
                        )..init(
                            year: state.uri.queryParameters['year']!,
                            guid: guid,
                          ),
                      ),
                    ],
                    child: const YearlyOverviewPage(),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: Pages.personalInfoEdit.path,
            name: Pages.personalInfoEdit.name,
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
                child: PersonalInfoEditPage(
                  navigatingFromFamily: state.extra != null,
                ),
              );
            },
          ),
          GoRoute(
            path: Pages.childrenOverview.path,
            name: Pages.childrenOverview.name,
            builder: (context, state) {
              var showAllowanceWarning = false;
              if (state.extra != null) {
                showAllowanceWarning = state.extra!.toString().contains('true');
              }
              context.read<ImpactGroupsCubit>().fetchImpactGroups();
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
                        FamilyHistoryCubit(getIt())..fetchHistory(),
                  ),
                ],
                child: const FamilyOverviewPage(),
              );
            },
          ),
          GoRoute(
            path: Pages.cachedChildrenOverview.path,
            name: Pages.cachedChildrenOverview.name,
            builder: (context, state) => BlocProvider(
              create: (_) => CachedMembersCubit(
                getIt(),
                getIt(),
                familyLeaderName:
                    context.read<AuthCubit>().state.user.firstName,
              )..loadFromCache(),
              child: const CachedFamilyOverviewPage(),
            ),
          ),
          GoRoute(
            path: Pages.childDetails.path,
            name: Pages.childDetails.name,
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
            path: Pages.editChild.path,
            name: Pages.editChild.name,
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
            path: Pages.addMember.path,
            name: Pages.addMember.name,
            builder: (context, state) {
              final familyAlreadyExists = state.extra! as bool;
              return BlocProvider(
                create: (_) => AddMemberCubit(getIt(), getIt()),
                child: AddMemberMainScaffold(
                  familyAlreadyExists: familyAlreadyExists,
                ),
              );
            },
          ),
          GoRoute(
            path: Pages.avatarSelection.path,
            name: Pages.avatarSelection.name,
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
                child: const AvatarSelectionScreen(),
              );
            },
          ),
          GoRoute(
            path: Pages.createFamilyGoal.path,
            name: Pages.createFamilyGoal.name,
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
            path: Pages.recurringDonations.path,
            name: Pages.recurringDonations.name,
            builder: (context, state) => BlocProvider(
              create: (_) => RecurringDonationsCubit(getIt(), getIt())
                ..fetchRecurringDonations(
                  context.read<AuthCubit>().state.user.guid,
                ),
              child: const RecurringDonationsOverviewPage(),
            ),
          ),
          GoRoute(
            path: Pages.registration.path,
            name: Pages.registration.name,
            builder: (context, state) {
              final email = state.uri.queryParameters['email'] ?? '';

              final createStripe = bool.parse(
                state.uri.queryParameters['createStripe'] ?? 'false',
              );
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) {
                      final registrationBloc = RegistrationBloc(
                        authCubit: context.read<AuthCubit>(),
                        authRepositoy: getIt(),
                      );

                      if (createStripe) {
                        registrationBloc.add(const RegistrationStripeInit());
                      }

                      return registrationBloc;
                    },
                  ),
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
            routes: [
              GoRoute(
                path: Pages.personalInfo.path,
                name: Pages.personalInfo.name,
                builder: (context, state) => BlocProvider.value(
                  value: state.extra! as RegistrationBloc,
                  child: const PersonalInfoPage(),
                ),
              ),
              GoRoute(
                path: Pages.creditCardDetails.path,
                name: Pages.creditCardDetails.name,
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
            ],
          ),
          GoRoute(
            path: Pages.permitBiometric.path,
            name: Pages.permitBiometric.name,
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
            path: Pages.registrationSuccess.path,
            name: Pages.registrationSuccess.name,
            builder: (_, state) => const RegistrationCompletedPage(),
          ),
          GoRoute(
            path: Pages.registrationSuccessUs.path,
            name: Pages.registrationSuccessUs.name,
            builder: (_, state) => const RegistrationSuccessUs(),
          ),
          GoRoute(
            path: Pages.joinImpactGroupSuccess.path,
            name: Pages.joinImpactGroupSuccess.name,
            builder: (context, state) => const ImpactGroupJoinSuccessPage(),
          ),
          GoRoute(
            path: Pages.impactGroupDetails.path,
            name: Pages.impactGroupDetails.name,
            builder: (context, state) => BlocProvider(
              create: (_) => GiveBloc(
                getIt(),
                getIt(),
                getIt(),
                getIt(),
              ),
              child: ImpactGroupDetailsPage(
                impactGroup: state.extra! as ImpactGroup,
              ),
            ),
          ),
          GoRoute(
            path: Pages.sepaMandateExplanation.path,
            name: Pages.sepaMandateExplanation.name,
            routes: [
              GoRoute(
                path: Pages.signSepaMandate.path,
                name: Pages.signSepaMandate.name,
                builder: (context, state) => BlocProvider.value(
                  value: state.extra! as RegistrationBloc,
                  child: const SignSepaMandatePage(),
                ),
              ),
              GoRoute(
                path: Pages.bacsMandateExplanation.path,
                name: Pages.bacsMandateExplanation.name,
                routes: [
                  GoRoute(
                    path: Pages.signBacsMandate.path,
                    name: Pages.signBacsMandate.name,
                    builder: (context, state) => BlocProvider.value(
                      value: state.extra! as RegistrationBloc,
                      child: const SignBacsMandatePage(),
                    ),
                  ),
                  GoRoute(
                    path: Pages.giftAid.path,
                    name: Pages.giftAid.name,
                    builder: (context, state) => BlocProvider(
                      create: (context) => RegistrationBloc(
                        authCubit: context.read<AuthCubit>(),
                        authRepositoy: getIt(),
                      )..add(const RegistrationInit()),
                      child: const GiftAidRequestPage(),
                    ),
                  ),
                ],
                builder: (context, state) => BlocProvider(
                  create: (context) => RegistrationBloc(
                    authCubit: context.read<AuthCubit>(),
                    authRepositoy: getIt(),
                  )..add(const RegistrationInit()),
                  child: const BacsExplanationPage(),
                ),
              ),
            ],
            builder: (context, state) => BlocProvider(
              create: (context) => RegistrationBloc(
                authCubit: context.read<AuthCubit>(),
                authRepositoy: getIt(),
              )..add(const RegistrationInit()),
              child: const MandateExplanationPage(),
            ),
          ),
          GoRoute(
            path: Pages.selectGivingWay.path,
            name: Pages.selectGivingWay.name,
            builder: (context, state) => BlocProvider(
              create: (_) {
                final extra = state.extra! as Map<String, dynamic>;
                final auth = context.read<AuthCubit>().state;
                final bloc = GiveBloc(
                  getIt(),
                  getIt(),
                  getIt(),
                  getIt(),
                )..add(
                    GiveAmountChanged(
                      firstCollectionAmount: extra['firstCollection'] as double,
                      secondCollectionAmount:
                          extra['secondCollection'] as double,
                      thirdCollectionAmount: extra['thirdCollection'] as double,
                    ),
                  );
                if ((extra['code'] as String).isNotEmpty) {
                  bloc.add(
                    GiveQRCodeScannedOutOfApp(
                      extra['code'] as String,
                      extra['afterGivingRedirection'] as String,
                      auth.user.guid,
                    ),
                  );
                }
                return bloc;
              },
              child: const SelectGivingWayPage(),
            ),
            routes: [
              GoRoute(
                path: Pages.giveByBeacon.path,
                name: Pages.giveByBeacon.name,
                builder: (context, state) => BlocProvider.value(
                  value: state.extra! as GiveBloc
                    ..add(
                      const GiveCheckLastDonation(),
                    ),
                  child: const BTScanPage(),
                ),
              ),
              GoRoute(
                path: Pages.giveByLocation.path,
                name: Pages.giveByLocation.name,
                builder: (context, state) => BlocProvider.value(
                  value: state.extra! as GiveBloc
                    ..add(
                      const GiveCheckLastDonation(),
                    ),
                  child: const GPSScanPage(),
                ),
              ),
              GoRoute(
                path: Pages.giveByQrCode.path,
                name: Pages.giveByQrCode.name,
                builder: (context, state) => BlocProvider.value(
                  value: state.extra! as GiveBloc,
                  child: const QrCodeScanPage(),
                ),
              ),
              GoRoute(
                path: Pages.giveByList.path,
                name: Pages.giveByList.name,
                builder: (context, state) {
                  final user = context.read<AuthCubit>().state.user;
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: state.extra! as GiveBloc,
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
                    ],
                    child: const OrganizationListPage(),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: Pages.give.path,
            name: Pages.give.name,
            builder: (context, state) => BlocProvider.value(
              value: state.extra! as GiveBloc,
              child: const GivingPage(),
            ),
          ),
          GoRoute(
            path: Pages.giveSucess.path,
            name: Pages.giveSucess.name,
            builder: (context, state) {
              final extra = state.extra! as Map<String, dynamic>;
              return SuccessDonationPage(
                organisationName: extra['orgName'] as String,
                isRecurringDonation: extra['isRecurringDonation'] as bool,
              );
            },
          ),
          GoRoute(
            path: Pages.chooseCategoryList.path,
            name: Pages.chooseCategoryList.name,
            builder: (context, state) {
              final user = context.read<AuthCubit>().state.user;
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => GiveBloc(
                      getIt(),
                      getIt(),
                      getIt(),
                      getIt(),
                    )..add(
                        const GiveCheckLastDonation(),
                      ),
                  ),
                  BlocProvider(
                    create: (_) => OrganisationBloc(
                      getIt(),
                      getIt(),
                    )..add(
                        OrganisationFetch(
                          Country.fromCode(user.country),

                          /// Disable last donated organisation
                          /// in the discover flow as it's
                          /// not present in the native app
                          showLastDonated: false,
                          type: state.extra != null && state.extra is int
                              ? state.extra! as int
                              : CollectGroupType.none.index,
                        ),
                      ),
                  ),
                ],
                child: const OrganizationListPage(
                  isChooseCategory: true,
                ),
              );
            },
          ),
          GoRoute(
            path: Pages.overview.path,
            name: Pages.overview.name,
            builder: (context, state) {
              return BlocProvider(
                create: (_) => GivtBloc(
                  getIt(),
                )..add(
                    const GivtInit(),
                  ),
                child: const OverviewPage(),
              );
            },
          ),
          GoRoute(
            path: Pages.unregister.path,
            name: Pages.unregister.name,
            builder: (_, state) => BlocProvider(
              create: (_) => UnregisterCubit(
                getIt(),
              ),
              child: const UnregisterPage(),
            ),
          ),
        ],
        builder: (context, routerState) => BlocListener<AuthCubit, AuthState>(
          listener: (context, state) =>
              _checkAndRedirectAuth(state, context, routerState),
          child: BlocProvider(
            create: (_) => RemoteDataSourceSyncBloc(
              getIt(),
              getIt(),
            )..add(const RemoteDataSourceSyncRequested()),
            child: HomePage(
              code: routerState.uri.queryParameters['code'] ?? '',
              afterGivingRedirection:
                  routerState.uri.queryParameters['afterGivingRedirection'] ??
                      '',
              given: routerState.uri.queryParameters.containsKey('given'),
              navigateTo: routerState.uri.queryParameters['page'] ?? '',
            ),
          ),
        ),
      ),
      GoRoute(
        path: Pages.profileSelection.path,
        name: Pages.profileSelection.name,
        builder: (_, routerState) => MultiBlocProvider(
          providers: [
            BlocListener<AuthCubit, AuthState>(
              listener: (context, state) =>
                  _checkAndRedirectAuth(state, context, routerState),
            ),
            BlocProvider<ProfilesCubit>(
              create: (BuildContext context) => ProfilesCubit(getIt()),
              lazy: true,
            ),
            BlocProvider<OrganisationDetailsCubit>(
              create: (BuildContext context) =>
                  OrganisationDetailsCubit(getIt()),
              lazy: true,
            ),
            BlocProvider<FlowsCubit>(
              create: (BuildContext context) => FlowsCubit(),
            ),
            BlocProvider<FamilyImpactGroupsCubit.ImpactGroupsCubit>(
              create: (BuildContext context) =>
                  FamilyImpactGroupsCubit.ImpactGroupsCubit(getIt()),
              lazy: true,
            ),
            BlocProvider(
              create: (context) => ScanNfcCubit(),
            ),
          ],
          child: Theme(
            data: const FamilyAppTheme().toThemeData(),
            child: const ProfileSelectionScreen(),
          ),
        ),
        routes: [
          GoRoute(
            path: Pages.wallet.path,
            name: Pages.wallet.name,
            builder: (context, state) {
              context.read<ProfilesCubit>().fetchActiveProfile();
              final user = context.read<ProfilesCubit>().state.activeProfile;
              context
                  .read<FamilyImpactGroupsCubit.ImpactGroupsCubit>()
                  .fetchImpactGroups(user.id, true);
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
            },
          ),
        ],
      ),
      GoRoute(
        path: Pages.welcome.path,
        name: Pages.welcome.name,
        builder: (_, routerState) => BlocListener<AuthCubit, AuthState>(
          listener: (context, state) =>
              _checkAndRedirectAuth(state, context, routerState),
          child: WelcomePage(
            prefs: getIt(),
          ),
        ),
      ),
    ],
  );

  /// This method is used to redirect the user to the correct page after
  /// clicking on a link in an email
  static FutureOr<String?> _redirectFromExternalLink(
    BuildContext context,
    GoRouterState state,
  ) {
    final auth = context.read<AuthCubit>().state;
    var code = '';
    var navigatingPage = '';
    var afterGivingRedirection = '';

    UTMHelper.trackToAnalytics(uri: state.uri);

    if (state.uri.queryParameters.containsKey('code')) {
      code = state.uri.queryParameters['code']!;
    }

    if (state.uri.queryParameters.containsKey('page')) {
      navigatingPage = state.uri.queryParameters['page']!;
    }

    if (state.uri.queryParameters.containsKey('from')) {
      afterGivingRedirection = state.uri.queryParameters['from']!;
    }

    /// If user comes from a custome url_scheme
    /// we have mediumId instead of
    /// code and needs to be encoded
    if (state.uri.queryParameters.containsKey('mediumId')) {
      code = base64Encode(utf8.encode(state.uri.queryParameters['mediumId']!));
    }

    if (state.uri.queryParameters.containsKey('mediumid')) {
      code = base64Encode(utf8.encode(state.uri.queryParameters['mediumid']!));
    }

    final params = <String, String>{};

    if (code.isNotEmpty) {
      params['code'] = code;
    }

    if (navigatingPage.isNotEmpty) {
      params['page'] = navigatingPage;
    }

    params['afterGivingRedirection'] = afterGivingRedirection;

    if (navigatingPage == Pages.generosityChallenge.path &&
        GenerosityChallengeHelper.isCompleted) {
      navigatingPage = '';
      params.remove('page');
    }

    final query = Uri(
      queryParameters: params,
    ).query;

    if (GenerosityChallengeHelper.isActivated ||
        (navigatingPage == Pages.generosityChallenge.path &&
            !GenerosityChallengeHelper.isCompleted)) {
      return Pages.generosityChallenge.path;
    }

    /// Display the splash screen while checking the auth status
    if (auth.status == AuthStatus.loading) {
      return '${Pages.loading.path}?$query';
    }

    if (auth.status == AuthStatus.authenticated) {
      return '${Pages.home.path}?$query';
    }

    return '${Pages.welcome.path}?$query';
  }

  /// Check if the user is authenticated and redirect to the correct page
  static Future<void> _checkAndRedirectAuth(
    AuthState state,
    BuildContext context,
    GoRouterState routerState,
  ) async {
    if (state.status == AuthStatus.biometricCheck) {
      context.goNamed(
        Pages.permitBiometric.name,
        extra: PermitBiometricRequest.login(),
      );
    }

    if (state.status == AuthStatus.authenticated) {
      if (state.hasNavigation) {
        final navigate = state.navigate;
        context.read<AuthCubit>().clearNavigation();
        await navigate(context);
        return;
      }

      if (routerState.name == Pages.home.name) {
        return;
      }

      if (state.user.isUsUser) {
        context.goNamed(Pages.profileSelection.name);
        return;
      }

      context.goNamed(
        Pages.home.name,
        queryParameters: routerState.uri.queryParameters,
      );
    }
    if (state.status == AuthStatus.unauthenticated ||
        state.status == AuthStatus.unknown) {
      context.goNamed(Pages.welcome.name);
    }
  }
}
