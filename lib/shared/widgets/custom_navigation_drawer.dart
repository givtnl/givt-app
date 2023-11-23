import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/amount_presets/pages/change_amount_presets_bottom_sheet.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/remote_data_source_sync/remote_data_source_sync_bloc.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/pages/pages.dart';
import 'package:givt_app/shared/widgets/about_givt_bottom_sheet.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

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
      child: ListView(
        children: [
          _buildGivtLogo(size),
          _buildMenuItem(
            isVisible: auth.user.needRegistration || !auth.user.mandateSigned,
            showBadge: true,
            showUnderline: false,
            title: locals.finalizeRegistration,
            icon: Icons.edit,
            onTap: () {
              if (auth.user.needRegistration) {
                final createStripe = auth.user.personalInfoRegistered &&
                    (auth.user.country == Country.us.countryCode);
                context
                  ..goNamed(
                    Pages.registration.name,
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
          _buildSummaryTile(size, locals, context),
          Divider(
            thickness: size.height * 0.02,
          ),
          _buildMenuItem(
            isVisible: !auth.user.needRegistration,
            isAccent: true,
            icon: Icons.wallet,
            title: locals.budgetMenuView,
            imageIcon: Image.asset(
              'assets/images/givy_budget_menu.png',
              fit: BoxFit.contain,
            ),
            onTap: () => AuthUtils.checkToken(
              context,
              navigate: () {
                context.goNamed(Pages.personalSummary.name);
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.personalSummaryClicked,
                );
              },
            ),
          ),
          _buildMenuItem(
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
            onTap: () => AuthUtils.checkToken(
              context,
              navigate: () {
                context.goNamed(Pages.childrenOverview.name);
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.familyClicked,
                );
              },
            ),
          ),
          if (showFamilyItem) _buildEmptySpace(),
          _buildMenuItem(
            isVisible: !auth.user.needRegistration,
            title: locals.historyTitle,
            icon: FontAwesomeIcons.listUl,
            onTap: () {
              context.read<RemoteDataSourceSyncBloc>().add(
                    const RemoteDataSourceSyncRequested(),
                  );
              AuthUtils.checkToken(
                context,
                navigate: () => context.goNamed(
                  Pages.overview.name,
                ),
              );
            },
          ),
          _buildMenuItem(
            isVisible: !auth.user.needRegistration,
            title: locals.menuItemRecurringDonation,
            icon: Icons.autorenew,
            onTap: () => AuthUtils.checkToken(
              context,
              navigate: () {
                context.goNamed(Pages.recurringDonations.name);
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.recurringDonationsClicked,
                );
              },
            ),
          ),
          _buildMenuItem(
            isVisible: !auth.user.needRegistration,
            title: locals.giveLimit,
            icon: Util.getCurrencyIconData(
              country: Country.fromCode(
                auth.user.country,
              ),
            ),
            onTap: () => AuthUtils.checkToken(
              context,
              navigate: () => showModalBottomSheet<void>(
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
          _buildMenuItem(
            isVisible: !auth.user.needRegistration,
            title: locals.personalInfo,
            icon: Icons.mode_edit_outline,
            onTap: () => AuthUtils.checkToken(
              context,
              navigate: () => context.goNamed(
                Pages.personalInfoEdit.name,
              ),
            ),
          ),
          _buildMenuItem(
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
          _buildMenuItem(
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

              return _buildMenuItem(
                isVisible: (isFingerprintAvailable || isFaceIdAvailable) &&
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
                onTap: () => AuthUtils.checkToken(
                  context,
                  navigate: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (_) => FingerprintBottomSheet(
                      isFingerprint: isFingerprintAvailable,
                    ),
                  ),
                ),
              );
            },
          ),
          _buildEmptySpace(),
          _buildMenuItem(
            isVisible: true,
            title: locals.logOut,
            icon: Icons.logout_sharp,
            onTap: () async {
              if (!await getIt<InternetConnectionCheckerPlus>().hasConnection) {
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
          _buildMenuItem(
            isVisible: true,
            showUnderline: false,
            title: locals.unregister,
            icon: FontAwesomeIcons.userXmark,
            onTap: () {
              if (auth.user.tempUser) {
                context.goNamed(
                  Pages.unregister.name,
                );
                return;
              }
              AuthUtils.checkToken(
                context,
                navigate: () => context.goNamed(
                  Pages.unregister.name,
                ),
              );
            },
          ),
          _buildEmptySpace(),
          _buildMenuItem(
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

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Widget? imageIcon,
    bool isVisible = false,
    bool showBadge = false,
    bool showUnderline = true,
    bool isAccent = false,
  }) =>
      Visibility(
        visible: isVisible,
        child: Column(
          children: [
            Container(
              height: isAccent ? 90 : 60,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.givtLightGray,
                    width: showUnderline ? 1 : 0,
                  ),
                ),
              ),
              child: isAccent
                  ? ListTile(
                      minVerticalPadding: 0,
                      contentPadding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                      title: Row(
                        children: [
                          imageIcon ??
                              Icon(
                                icon,
                                color: AppTheme.givtBlue,
                              ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                          ),
                        ],
                      ),
                      onTap: onTap,
                    )
                  : ListTile(
                      leading: imageIcon ??
                          Icon(
                            icon,
                            color: AppTheme.givtBlue,
                          ),
                      trailing: badges.Badge(
                        showBadge: showBadge,
                        position:
                            badges.BadgePosition.topStart(top: 6, start: -20),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                        ),
                      ),
                      title: Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              isAccent ? FontWeight.w900 : FontWeight.normal,
                        ),
                      ),
                      onTap: onTap,
                    ),
            ),
          ],
        ),
      );

  Widget _buildSummaryTile(
    Size size,
    AppLocalizations locals,
    BuildContext context, {
    bool isVisible = false,
  }) {
    return Visibility(
      visible: isVisible,
      child: SizedBox(
        height: size.height * 0.10,
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/givy_budget_menu.png',
                  height: size.height * 0.1,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: locals.budgetMenuView,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.02,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                          ),
                        ),
                      ),
                    ],
                  ),
                  softWrap: true,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
