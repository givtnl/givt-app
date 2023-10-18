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
import 'package:givt_app/features/children/create_child/cubit/create_child_cubit.dart';
import 'package:givt_app/features/children/create_child/pages/create_child_page.dart';
import 'package:givt_app/features/children/details/cubit/child_details_cubit.dart';
import 'package:givt_app/features/children/details/pages/child_details_page.dart';
import 'package:givt_app/features/children/edit_child/cubit/edit_child_cubit.dart';
import 'package:givt_app/features/children/edit_child/pages/edit_child_page.dart';
import 'package:givt_app/features/children/overview/cubit/children_overview_cubit.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/features/children/overview/pages/children_overview_page.dart';
import 'package:givt_app/features/children/vpc/cubit/vpc_cubit.dart';
import 'package:givt_app/features/children/vpc/pages/give_vpc_page.dart';
import 'package:givt_app/features/first_use/pages/welcome_page.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/pages/bt_scan_page.dart';
import 'package:givt_app/features/give/pages/giving_page.dart';
import 'package:givt_app/features/give/pages/gps_scan_page.dart';
import 'package:givt_app/features/give/pages/home_page.dart';
import 'package:givt_app/features/give/pages/organization_list_page.dart';
import 'package:givt_app/features/give/pages/qr_code_scan_page.dart';
import 'package:givt_app/features/give/pages/select_giving_way_page.dart';
import 'package:givt_app/features/give/pages/success_donation_page.dart';
import 'package:givt_app/features/overview/bloc/givt_bloc.dart';
import 'package:givt_app/features/overview/pages/overview_page.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/cubit/add_external_donation_cubit.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/pages/add_external_donation_page.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/features/personal_summary/overview/pages/personal_summary_page.dart';
import 'package:givt_app/features/recurring_donations/overview/cubit/recurring_donations_cubit.dart';
import 'package:givt_app/features/recurring_donations/overview/pages/recurring_donations_overview_page.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/features/registration/pages/bacs_explanation_page.dart';
import 'package:givt_app/features/registration/pages/gift_aid_request_page.dart';
import 'package:givt_app/features/registration/pages/mandate_explanation_page.dart';
import 'package:givt_app/features/registration/pages/personal_info_page.dart';
import 'package:givt_app/features/registration/pages/sign_bacs_mandate_page.dart';
import 'package:givt_app/features/registration/pages/sign_sepa_mandate_page.dart';
import 'package:givt_app/features/registration/pages/signup_page.dart';
import 'package:givt_app/features/unregister_account/cubit/unregister_cubit.dart';
import 'package:givt_app/features/unregister_account/unregister_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/remote_data_source_sync/remote_data_source_sync_bloc.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
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
        path: Pages.home.path,
        name: Pages.home.name,
        routes: [
          GoRoute(
            path: Pages.personalSummary.path,
            name: Pages.personalSummary.name,
            builder: (context, state) => BlocProvider(
              create: (_) => PersonalSummaryBloc(
                loggedInUserExt: context.read<AuthCubit>().state.user,
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
            ],
          ),
          GoRoute(
            path: Pages.personalInfoEdit.path,
            name: Pages.personalInfoEdit.name,
            builder: (context, state) => BlocProvider(
              create: (_) => PersonalInfoEditBloc(
                loggedInUserExt: context.read<AuthCubit>().state.user,
                authRepositoy: getIt(),
              ),
              child: const PersonalInfoEditPage(),
            ),
          ),
          GoRoute(
            path: Pages.childrenOverview.path,
            name: Pages.childrenOverview.name,
            builder: (context, state) => BlocProvider(
              create: (_) => ChildrenOverviewCubit(getIt())
                ..fetchChildren(context.read<AuthCubit>().state.user.guid),
              child: const ChildrenOverviewPage(),
            ),
          ),
          GoRoute(
            path: Pages.childDetails.path,
            name: Pages.childDetails.name,
            builder: (context, state) {
              return BlocProvider(
                create: (_) => ChildDetailsCubit(getIt())
                  ..fetchChildDetails(state.extra! as Profile),
                child: const ChildDetailsPage(),
              );
            },
          ),
          GoRoute(
            path: Pages.editChild.path,
            name: Pages.editChild.name,
            builder: (context, state) {
              final childDetailsCubit = state.extra! as ChildDetailsCubit;
              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: childDetailsCubit,
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
            path: Pages.giveVPC.path,
            name: Pages.giveVPC.name,
            builder: (context, state) {
              context.read<VPCCubit>().showVPCInfo();
              return const GiveVPCPage();
            },
          ),
          GoRoute(
            path: Pages.createChild.path,
            name: Pages.createChild.name,
            builder: (context, state) => BlocProvider(
              create: (_) =>
                  CreateChildCubit(getIt(), AppLocalizations.of(context)),
              child: const CreateChildPage(),
            ),
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
              final email = state.queryParameters['email'] ?? '';

              final createStripe =
                  state.queryParameters['createStripe'] ?? 'false';
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => StripeCubit(
                      authRepositoy: getIt(),
                      authCubit: context.read<AuthCubit>(),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => RegistrationBloc(
                      authCubit: context.read<AuthCubit>(),
                      authRepositoy: getIt(),
                    ),
                  ),
                ],
                child: SignUpPage(
                  email: email,
                  createStripe: createStripe,
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
            ],
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
                      )
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
                  )
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
              code: routerState.queryParameters['code'] ?? '',
              given: routerState.queryParameters.containsKey('given'),
            ),
          ),
        ),
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
    if (state.queryParameters.containsKey('code')) {
      code = state.queryParameters['code']!;
    }

    /// If user comes from a custome url_scheme
    /// we have mediumId instead of
    /// code and needs to be encoded
    if (state.queryParameters.containsKey('mediumId')) {
      code = base64Encode(utf8.encode(state.queryParameters['mediumId']!));
    }
    if (auth.status == AuthStatus.authenticated) {
      if (code.isEmpty) {
        return Pages.home.path;
      }
      return '${Pages.home.path}?code=$code';
    }
    if (code.isEmpty) {
      return Pages.welcome.path;
    }
    return '${Pages.welcome.path}?code=$code';
  }

  /// Check if the user is authenticated and redirect to the correct page
  static void _checkAndRedirectAuth(
    AuthState state,
    BuildContext context,
    GoRouterState routerState,
  ) {
    if (state.status == AuthStatus.authenticated) {
      context.goNamed(
        Pages.home.name,
        queryParameters: routerState.queryParameters,
      );
    }
    if (state.status == AuthStatus.unauthenticated ||
        state.status == AuthStatus.unknown) {
      context.goNamed(Pages.welcome.name);
    }
  }
}
