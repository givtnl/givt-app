import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/account_details/pages/personal_info_edit_page.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/family_routes.dart';
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
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/impact_groups/pages/impact_group_details_page.dart';
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
import 'package:givt_app/features/registration/pages/pages.dart';
import 'package:givt_app/features/unregister_account/cubit/unregister_cubit.dart';
import 'package:givt_app/features/unregister_account/unregister_page.dart';
import 'package:givt_app/shared/bloc/remote_data_source_sync/remote_data_source_sync_bloc.dart';
import 'package:givt_app/shared/pages/pages.dart';
import 'package:givt_app/shared/pages/redirect_to_browser_page.dart';
import 'package:givt_app/shared/widgets/extensions/string_extensions.dart';
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
      // TEMP FIX FOR EXTERNAL KIDS LINKS
      GoRoute(
        path: '/search-for-coin',
        name: 'search-for-coin',
        builder: (context, routerState) => BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.loading) {
              // do nothing
              return;
            }
            if (state.status == AuthStatus.authenticated) {
              context.go(
                '${FamilyPages.profileSelection.path}/${FamilyPages.searchForCoin.path}?${routerState.uri.query}',
              );
            } else {
              final isTestApp = getIt<AppConfig>().isTestApp;
              final code = routerState.uri.queryParameters['code'];
              if (isTestApp && code != null) {
                context.go(
                  '${Pages.redirectToBrowser.path}?uri=https://dev-coin.givt.app/?mediumId=$code',
                );
              } else {
                context.go(
                  '${Pages.redirectToBrowser.path}?uri=${routerState.uri}',
                );
              }
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.redirectCoinToNoAppFlow,
                eventProperties: {
                  'url': routerState.uri.toString(),
                },
              );
            }
          },
          child: Builder(
            builder: (context) {
              context.read<AuthCubit>().checkAuth();
              return const LoadingPage();
            },
          ),
        ),
      ),
      GoRoute(
        path: Pages.redirectToBrowser.path,
        name: Pages.redirectToBrowser.name,
        builder: (context, state) {
          final uri = state.uri.queryParameters['uri'];
          return RedirectToBrowserPage(
            uri: uri ?? 'https://givt.app/search-for-coin?${state.uri.query}',
          );
        },
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
        path: Pages.home.path,
        name: Pages.home.name,
        routes: [
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
                      authRepository: getIt(),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => StripeCubit(
                      authRepository: getIt(),
                    ),
                  ),
                ],
                child: const PersonalInfoEditPage(),
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

              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => StripeCubit(
                      authRepository: getIt(),
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
            ],
          ),
          GoRoute(
            path: Pages.registrationSuccess.path,
            name: Pages.registrationSuccess.name,
            builder: (_, state) => const RegistrationCompletedPage(),
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
        redirect: (context, state) {
          final auth = context.read<AuthCubit>().state;
          if (auth.status == AuthStatus.authenticated &&
              auth.user.isUsUser &&
              !auth.user.needRegistration) {
            return FamilyPages.profileSelection.path;
          } else {
            return null;
          }
        },
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
      // Family features
      ...FamilyAppRoutes.routes,
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

    final query = Uri(
      queryParameters: params,
    ).query;

    /// Display the splash screen while checking the auth status
    if (auth.status == AuthStatus.loading) {
      return '${Pages.loading.path}?$query';
    }

    if (auth.status == AuthStatus.authenticated) {
      if (auth.user.isUsUser) {
        return navigatingPage.isNotNullAndNotEmpty()
            ? '${FamilyPages.profileSelection.path}?$query'
            : '${FamilyPages.profileSelection.path}${state.uri}';
      } else {
        return '${Pages.home.path}?$query';
      }
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
      await context.pushNamed(
        state.user.isUsUser
            ? FamilyPages.permitUSBiometric.name
            : Pages.permitBiometric.name,
        extra: PermitBiometricRequest.login(),
      );
      return;
    }

    if (state.status == AuthStatus.authenticated) {
      if (state.hasNavigation) {
        context.read<AuthCubit>().clearNavigation();
        await state.navigate(context, isUSUser: state.user.isUsUser);
        return;
      }

      if (state.user.isUsUser) {
        if (state.user.needRegistration) {
          // Prevent that users will see the profileselection page first when
          // registration is not finished (yet)
          context.pushReplacementNamed(
            FamilyPages.registrationUS.name,
            queryParameters: {
              'email': state.user.email,
            },
          );
        } else {
          context.goNamed(
            FamilyPages.profileSelection.name,
            queryParameters: routerState.uri.queryParameters,
          );
        }

        // US should not see the original home page
        return;
      }

      //needs to be after isUsUser check
      if (routerState.name == Pages.home.name) {
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
