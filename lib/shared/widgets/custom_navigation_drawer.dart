import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/core/feature_flags.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/remote_data_source_sync/remote_data_source_sync_bloc.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/feature_flag_builder.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final auth = context.watch<AuthCubit>().state;
    final theme = FunTheme.of(context);
    final iconColor = theme.primary20;

    return Drawer(
      backgroundColor: Colors.white,
      width: 304,
      child: auth.status == AuthStatus.loading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(top: 40),
                      children: [
                        _buildGivtLogo(),
                        _buildDecorativeAvatar(context),
                        DrawerMenuItem(
                          isVisible: auth.user.needRegistration ||
                              !auth.user.mandateSigned,
                          showBadge: true,
                          title: locals.finalizeRegistration,
                          leading: Icon(Icons.edit, size: 20, color: iconColor),
                          analyticsEvent: AnalyticsEventName
                              .menuNavigationFinalizeRegistrationClicked,
                          onTap: () {
                            if (auth.user.needRegistration) {
                              context
                                ..goNamed(
                                  Pages.registration.name,
                                  queryParameters: {
                                    'email': auth.user.email,
                                  },
                                )
                                ..pop();
                              return;
                            }
                            context.goNamed(
                              Pages.sepaMandateExplanation.name,
                            );
                          },
                        ),
                        DrawerMenuItem(
                          isVisible: !auth.user.needRegistration,
                          title: locals.budgetMenuView,
                          leading: FaIcon(
                            FontAwesomeIcons.list,
                            size: 20,
                            color: iconColor,
                          ),
                          analyticsEvent:
                              AnalyticsEventName.menuNavigationBudgetClicked,
                          onTap: () async => AuthUtils.checkToken(
                            context,
                            checkAuthRequest: CheckAuthRequest(
                              navigate: (context) async {
                                context.goNamed(Pages.personalSummary.name);
                                unawaited(
                                  AnalyticsHelper.logEvent(
                                    eventName: AnalyticsEventName
                                        .personalSummaryClicked,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        DrawerMenuItem(
                          isVisible: !auth.user.needRegistration,
                          title: locals.historyTitle,
                          leading: FaIcon(
                            FontAwesomeIcons.clockRotateLeft,
                            size: 20,
                            color: iconColor,
                          ),
                          analyticsEvent:
                              AnalyticsEventName.menuNavigationHistoryClicked,
                          onTap: () async {
                            context.read<RemoteDataSourceSyncBloc>().add(
                                  const RemoteDataSourceSyncRequested(),
                                );
                            await AuthUtils.checkToken(
                              context,
                              checkAuthRequest: CheckAuthRequest(
                                navigate: (context) async => context.goNamed(
                                  Pages.donationOverview.name,
                                ),
                              ),
                            );
                          },
                        ),
                        DrawerMenuItem(
                          isVisible: !auth.user.needRegistration,
                          title: locals.menuItemRecurringDonation,
                          leading: FaIcon(
                            FontAwesomeIcons.arrowsRotate,
                            size: 20,
                            color: iconColor,
                          ),
                          analyticsEvent: AnalyticsEventName
                              .menuNavigationRecurringDonationClicked,
                          onTap: () async => AuthUtils.checkToken(
                            context,
                            checkAuthRequest: CheckAuthRequest(
                              navigate: (context) async {
                                context.goNamed(Pages.recurringDonations.name);
                                unawaited(
                                  AnalyticsHelper.logEvent(
                                    eventName: AnalyticsEventName
                                        .recurringDonationsNavigationClicked,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        DrawerMenuItem(
                          isVisible: !auth.user.needRegistration,
                          title: locals.menuItemExternalDonations,
                          leading: FaIcon(
                            FontAwesomeIcons.arrowUpRightFromSquare,
                            size: 20,
                            color: iconColor,
                          ),
                          analyticsEvent: AnalyticsEventName
                              .menuNavigationExternalDonationsClicked,
                          onTap: () async => AuthUtils.checkToken(
                            context,
                            checkAuthRequest: CheckAuthRequest(
                              navigate: (context) async {
                                context.goNamed(Pages.externalDonations.name);
                                unawaited(
                                  AnalyticsHelper.logEvent(
                                    eventName: AnalyticsEventName
                                        .externalDonationsNavigationClicked,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        FeatureFlagBuilder(
                          featureFlagKey: FeatureFlags.showPledges,
                          builder: (context, isEnabled) {
                            return DrawerMenuItem(
                              isVisible:
                                  !auth.user.needRegistration && isEnabled,
                              title: locals.menuItemPledges,
                              leading: FaIcon(
                                FontAwesomeIcons.handHoldingHeart,
                                size: 20,
                                color: iconColor,
                              ),
                              analyticsEvent: AnalyticsEventName
                                  .menuNavigationPledgesClicked,
                              onTap: () async => AuthUtils.checkToken(
                                context,
                                checkAuthRequest: CheckAuthRequest(
                                  navigate: (context) async {
                                    context.goNamed(Pages.pledges.name);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  DrawerMenuItem(
                    title: locals.accountSettingsTitle,
                    leading: FaIcon(
                      FontAwesomeIcons.gear,
                      size: 20,
                      color: iconColor,
                    ),
                    semanticsIdentifier: 'menuAccountSettings',
                    analyticsEvent: AnalyticsEventName
                        .menuNavigationAccountSettingsClicked,
                    onTap: () async => AuthUtils.checkToken(
                      context,
                      checkAuthRequest: CheckAuthRequest(
                        navigate: (context) async => context.goNamed(
                          Pages.personalInfoEdit.name,
                        ),
                      ),
                    ),
                  ),
                  DrawerMenuItem(
                    title: locals.menuItemContact,
                    leading: FaIcon(
                      FontAwesomeIcons.circleInfo,
                      size: 20,
                      color: iconColor,
                    ),
                    analyticsEvent:
                        AnalyticsEventName.menuNavigationAboutGivtClicked,
                    onTap: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (_) => const AboutGivtBottomSheet(),
                    ),
                  ),
                  DrawerMenuItem(
                    title: locals.menuItemLogOut,
                    leading: FaIcon(
                      FontAwesomeIcons.arrowRightFromBracket,
                      size: 20,
                      color: iconColor,
                    ),
                    analyticsEvent:
                        AnalyticsEventName.menuNavigationLogoutClicked,
                    onTap: () async {
                      if (!getIt<NetworkInfo>().isConnected) {
                        if (!context.mounted) {
                          return;
                        }
                        await showDialog<void>(
                          context: context,
                          builder: (_) => WarningDialog(
                            title: locals.noInternetConnectionTitle,
                            content: locals.noInternet,
                          ),
                        );
                        return;
                      }
                      if (!context.mounted) {
                        return;
                      }
                      return context.read<AuthCubit>().logout();
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildDecorativeAvatar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: ExcludeSemantics(
          child: Image.asset(
            'assets/images/givy_wink_green.png',
            width: 80,
            height: 80,
          ),
        ),
      ),
    );
  }

  Widget _buildGivtLogo() => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Center(
          child: SizedBox(
            height: 24,
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),
        ),
      );
}
