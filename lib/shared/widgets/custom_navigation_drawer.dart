import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/features/amount_presets/pages/change_amount_presets_bottom_sheet.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/utils/cached_family_utils.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/remote_data_source_sync/remote_data_source_sync_bloc.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/pages/pages.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final locals = context.l10n;
    final auth = context.watch<AuthCubit>().state;

    final showFamilyItem = auth.user.country == Country.us.countryCode &&
        !auth.user.needRegistration &&
        auth.user.mandateSigned;
    return Drawer(
      child: auth.status == AuthStatus.loading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ListView(
              children: [
                _buildGivtLogo(size),
                DrawerMenuItem(
                  isVisible:
                      auth.user.needRegistration || !auth.user.mandateSigned,
                  showBadge: true,
                  title: locals.finalizeRegistration,
                  icon: Icons.edit,
                  onTap: () {
                    if (auth.user.needRegistration) {
                      final createStripe = auth.user.personalInfoRegistered &&
                          (auth.user.country == Country.us.countryCode);
                      context
                        ..goNamed(
                          createStripe
                              ? FamilyPages.registrationUS.name
                              : Pages.registration.name,
                          queryParameters: {
                            'email': auth.user.email,
                            'createStripe': createStripe.toString(),
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
                // Divider(
                //   thickness: size.height * 0.03,
                // ),
                const SummaryMenuItem(),
                Divider(
                  thickness: size.height * 0.02,
                ),
                DrawerMenuItem(
                  isVisible: !auth.user.needRegistration,
                  isAccent: true,
                  icon: Icons.wallet,
                  title: locals.budgetMenuView,
                  imageIcon: Image.asset(
                    'assets/images/givy_budget_menu.png',
                    fit: BoxFit.contain,
                  ),
                  onTap: () async => AuthUtils.checkToken(
                    context,
                    checkAuthRequest: CheckAuthRequest(
                      navigate: (context, {isUSUser}) async {
                        context.goNamed(Pages.personalSummary.name);
                        unawaited(
                          AnalyticsHelper.logEvent(
                            eventName: AmplitudeEvents.personalSummaryClicked,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                DrawerMenuItem(
                  isVisible: showFamilyItem,
                  title: locals.childrenMyFamily,
                  isAccent: true,
                  imageIcon: Container(
                    padding: const EdgeInsets.all(10),
                    width: 90,
                    child: SvgPicture.asset(
                      'assets/images/givt4kids_logo.svg',
                    ),
                  ),
                  icon: Icons.family_restroom_rounded,
                  onTap: () async => AuthUtils.checkToken(
                    context,
                    checkAuthRequest: CheckAuthRequest(
                      navigate: (context, {isUSUser}) async {
                        if (CachedFamilyUtils.isFamilyCacheExist()) {
                          context.goNamed(
                            FamilyPages.cachedChildrenOverview.name,
                          );
                        } else {
                          context.goNamed(FamilyPages.childrenOverview.name);
                        }
                        unawaited(
                          AnalyticsHelper.logEvent(
                            eventName: AmplitudeEvents.familyClicked,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (showFamilyItem) _buildEmptySpace(),
                DrawerMenuItem(
                  isVisible: !auth.user.needRegistration,
                  title: locals.historyTitle,
                  icon: FontAwesomeIcons.listUl,
                  onTap: () async {
                    context.read<RemoteDataSourceSyncBloc>().add(
                          const RemoteDataSourceSyncRequested(),
                        );
                    await AuthUtils.checkToken(
                      context,
                      checkAuthRequest: CheckAuthRequest(
                        navigate: (context, {isUSUser}) async =>
                            context.goNamed(
                          Pages.overview.name,
                        ),
                      ),
                    );
                  },
                ),
                DrawerMenuItem(
                  isVisible: !auth.user.needRegistration,
                  title: locals.menuItemRecurringDonation,
                  icon: Icons.autorenew,
                  onTap: () async => AuthUtils.checkToken(
                    context,
                    checkAuthRequest: CheckAuthRequest(
                      navigate: (context, {isUSUser}) async {
                        context.goNamed(Pages.recurringDonations.name);
                        unawaited(
                          AnalyticsHelper.logEvent(
                            eventName:
                                AmplitudeEvents.recurringDonationsClicked,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                DrawerMenuItem(
                  isVisible: !auth.user.needRegistration,
                  title: locals.giveLimit,
                  icon: Util.getCurrencyIconData(
                    country: Country.fromCode(
                      auth.user.country,
                    ),
                  ),
                  onTap: () async => AuthUtils.checkToken(
                    context,
                    checkAuthRequest: CheckAuthRequest(
                      navigate: (context, {isUSUser}) =>
                          showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (_) => ChangeMaxAmountBottomSheet(
                          maxAmount: auth.user.amountLimit,
                          icon: Util.getCurrencyIconData(
                            country: Country.fromCode(
                              auth.user.country,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                DrawerMenuItem(
                  isVisible: !auth.user.needRegistration,
                  title: locals.personalInfo,
                  icon: Icons.mode_edit_outline,
                  onTap: () async => AuthUtils.checkToken(
                    context,
                    checkAuthRequest: CheckAuthRequest(
                      navigate: (context, {isUSUser}) async => context.goNamed(
                        Pages.personalInfoEdit.name,
                      ),
                    ),
                  ),
                ),
                DrawerMenuItem(
                  isVisible: !auth.user.needRegistration,
                  title: locals.amountPresetsTitle,
                  icon: Icons.tune,
                  imageIcon: Transform.rotate(
                    angle: 1.57,
                    child: const Icon(
                      Icons.tune,
                      color: AppTheme.givtBlue,
                    ),
                  ),
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (_) => const ChangeAmountPresetsBottomSheet(),
                  ),
                ),
                DrawerMenuItem(
                  title: locals.pincode,
                  icon: Icons.lock_outline_sharp,
                  onTap: () {},
                ),
                FutureBuilder(
                  initialData: false,
                  future: Future.wait<bool>([
                    LocalAuthInfo.instance.checkFingerprint(),
                    LocalAuthInfo.instance.checkFaceId(),
                  ]),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const SizedBox.shrink();
                    }
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }
                    if (snapshot.data == null) {
                      return const SizedBox.shrink();
                    }

                    final data = snapshot.data! as List<bool>;
                    final isFingerprintAvailable = data[0];
                    final isFaceIdAvailable = data[1];

                    return DrawerMenuItem(
                      isVisible:
                          (isFingerprintAvailable || isFaceIdAvailable) &&
                              !auth.user.tempUser,
                      title: isFingerprintAvailable
                          ? Platform.isAndroid
                              ? locals.fingerprintTitle
                              : locals.touchId
                          : locals.faceId,
                      icon: Icons.fingerprint,
                      imageIcon: Platform.isIOS && isFaceIdAvailable
                          ? SvgPicture.asset(
                              'assets/images/face_id.svg',
                              width: 24,
                              color: AppTheme.givtBlue,
                            )
                          : null,
                      onTap: () async => AuthUtils.checkToken(
                        context,
                        checkAuthRequest: CheckAuthRequest(
                          navigate: (context, {isUSUser}) =>
                              showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            builder: (_) => FingerprintBottomSheet(
                              isFingerprint: isFingerprintAvailable,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                _buildEmptySpace(),
                DrawerMenuItem(
                  isVisible: true,
                  title: locals.logOut,
                  icon: Icons.logout_sharp,
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
                DrawerMenuItem(
                  isVisible: true,
                  title: locals.unregister,
                  icon: FontAwesomeIcons.userXmark,
                  onTap: () async {
                    if (auth.user.tempUser) {
                      context.goNamed(
                        Pages.unregister.name,
                      );
                      return;
                    }
                    await AuthUtils.checkToken(
                      context,
                      checkAuthRequest: CheckAuthRequest(
                        navigate: (context, {isUSUser}) async =>
                            context.goNamed(
                          Pages.unregister.name,
                        ),
                      ),
                    );
                  },
                ),
                _buildEmptySpace(),
                DrawerMenuItem(
                  isVisible: true,
                  title: locals.titleAboutGivt,
                  icon: Icons.info,
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (_) => const AboutGivtBottomSheet(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptySpace() => Container(
        height: 20,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 240, 240, 240),
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 173, 173, 173),
              width: 0.5,
            ),
            bottom: BorderSide(
              color: Color.fromARGB(255, 173, 173, 173),
              width: 0.5,
            ),
          ),
        ),
      );

  Widget _buildGivtLogo(Size size) => Container(
        margin: EdgeInsets.only(
          bottom: size.height * 0.02,
        ),
        height: size.height * 0.03,
        child: Image.asset(
          'assets/images/logo.png',
        ),
      );
}
