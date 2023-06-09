import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/pages/login_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/about_givt_bottom_sheet.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = AppLocalizations.of(context);
    final auth = context.read<AuthCubit>().state;
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
          // Divider(
          //   thickness: size.height * 0.02,
          // ),
          _buildMenuItem(
            isVisible: true,
            title: locals.historyTitle,
            icon: FontAwesomeIcons.listUl,
            onTap: () => _checkToken(context, route: Pages.overview.name),
          ),
          _buildMenuItem(
            title: locals.giveLimit,
            icon: Icons.euro,
            onTap: () {},
          ),
          _buildMenuItem(
            isVisible: !auth.user.needRegistration,
            title: locals.personalInfo,
            icon: Icons.mode_edit_outline,
            onTap: () => _checkToken(
              context,
              route: Pages.personalInfoEdit.name,
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
          _buildMenuItem(
            title: locals.touchId,
            icon: Icons.fingerprint,
            onTap: () {},
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
            onTap: () => _checkToken(context, route: Pages.unregister.name),
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
                leading: Icon(
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

  void _checkToken(
    BuildContext context, {
    required String route,
  }) {
    final auth = context.read<AuthCubit>();
    final isExpired = auth.state.session.isExpired;
    if (!isExpired) {
      context.goNamed(route);
      return;
    }
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
      context.goNamed(route);
    });
  }
}
