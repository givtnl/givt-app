import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/pages/login_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/pages/pages.dart';
import 'package:givt_app/shared/widgets/about_givt_bottom_sheet.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/util.dart';
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
                context.goNamed(
                  Pages.registration.name,
                  queryParameters: {
                    'email': auth.user.email,
                  },
                );
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
            title: locals.historyTitle,
            icon: FontAwesomeIcons.listUl,
            onTap: () => _checkToken(
              context,
              navigate: () => context.goNamed(
                Pages.overview.name,
              ),
            ),
          ),
          _buildMenuItem(
            title: locals.giveLimit,
            icon: Util.getCurrencyIconData(
              country: Country.fromCode(
                auth.user.country,
              ),
            ),
            onTap: () {},
          ),
          _buildMenuItem(
            isVisible: !auth.user.needRegistration,
            title: locals.personalInfo,
            icon: Icons.mode_edit_outline,
            onTap: () => _checkToken(
              context,
              navigate: () => context.goNamed(
                Pages.personalInfoEdit.name,
              ),
            ),
          ),
          _buildMenuItem(
            title: locals.amountPresetsTitle,
            icon: Icons.settings_input_component,
            onTap: () {},
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
                isVisible: isFingerprintAvailable || isFaceIdAvailable,
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
                onTap: () => _checkToken(
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
            onTap: () async => context.read<AuthCubit>().logout(),
          ),
          _buildMenuItem(
            isVisible: true,
            showUnderline: false,
            title: locals.unregister,
            icon: FontAwesomeIcons.userXmark,
            onTap: () => _checkToken(
              context,
              navigate: () => context.goNamed(
                Pages.unregister.name,
              ),
            ),
          ),
          if (showFamilyItem) _buildEmptySpace(),
          _buildMenuItem(
            isVisible: showFamilyItem,
            title: locals.familyMenuItem,
            icon: Icons.family_restroom_rounded,
            onTap: () => context.goNamed(Pages.giveVPC.name),
          ),
          _buildEmptySpace(),
          _buildMenuItem(
            isVisible: true,
            title: locals.titleAboutGivt,
            icon: Icons.info,
            onTap: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
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
  }) =>
      Visibility(
        visible: isVisible,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.givtLightGray,
                    width: showUnderline ? 1 : 0,
                  ),
                ),
              ),
              child: ListTile(
                leading: imageIcon ??
                    Icon(
                      icon,
                      color: AppTheme.givtBlue,
                    ),
                trailing: badges.Badge(
                  showBadge: showBadge,
                  position: badges.BadgePosition.topStart(top: 6, start: -20),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
                title: Text(
                  title,
                  style: const TextStyle(fontSize: 17),
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

  Future<void> _checkToken(
    BuildContext context, {
    required VoidCallback navigate,
  }) async {
    final auth = context.read<AuthCubit>();
    final isExpired = auth.state.session.isExpired;
    if (!isExpired) {
      navigate();
      return;
    }
    if (!await LocalAuthInfo.instance.canCheckBiometrics) {
      // ignore: use_build_context_synchronously
      if (!context.mounted) {
        return;
      }
      _passwordLogin(context, auth: auth, navigate: navigate);
      return;
    }
    try {
      final hasAuthenticated = await LocalAuthInfo.instance.authenticate();
      if (!hasAuthenticated) {
        return;
      }
      // ignore: use_build_context_synchronously
      if (!context.mounted) {
        return;
      }
      await context.read<AuthCubit>().refreshSession();
      navigate();
    } on PlatformException catch (e) {
      await LoggingInfo.instance.info(
        'Error while authenticating with biometrics: ${e.message}',
      );
      // ignore: use_build_context_synchronously
      if (!context.mounted) {
        return;
      }
      _passwordLogin(context, auth: auth, navigate: navigate);
    }
  }

  void _passwordLogin(
    BuildContext context, {
    required AuthCubit auth,
    required VoidCallback navigate,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => LoginPage(
        email: auth.state.user.email,
        popWhenSuccess: true,
      ),
    ).whenComplete(() {
      if (context.read<AuthCubit>().state.session.isExpired) {
        return;
      }
      navigate();
    });
  }
}
