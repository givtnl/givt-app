import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/about_givt_bottom_sheet.dart';
import 'package:go_router/go_router.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = AppLocalizations.of(context);
    final auth = context.read<AuthCubit>().state as AuthSuccess;
    return Drawer(
      child: ListView(
        children: [
          _buildGivtLogo(size),
          _buildMenuItem(
            isVisible: auth.user.needRegistration || !auth.user.mandateSigned,
            showBadge: true,
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
          //   indent: size.width * 0.05,
          // ),
          // Divider(
          //   thickness: size.height * 0.03,
          // ),
          _buildSummaryTile(size, locals, context),
          // Divider(
          //   thickness: size.height * 0.02,
          // ),
          _buildMenuItem(
            title: locals.historyTitle,
            icon: Icons.receipt_long,
            onTap: () {},
          ),
          // Divider(
          //   indent: size.width * 0.05,
          // ),
          _buildMenuItem(
            title: locals.giveLimit,
            icon: Icons.euro,
            onTap: () {},
          ),
          // Divider(
          //   indent: size.width * 0.05,
          // ),
          _buildMenuItem(
            title: locals.personalInfo,
            icon: Icons.mode_edit_outline,
            onTap: () {},
          ),
          // Divider(
          //   indent: size.width * 0.05,
          // ),
          _buildMenuItem(
            title: locals.amountPresetsTitle,
            icon: Icons.settings_input_component,
            onTap: () {},
          ),
          // Divider(
          //   indent: size.width * 0.05,
          // ),
          _buildMenuItem(
            title: locals.pincode,
            icon: Icons.lock_outline_sharp,
            onTap: () {},
          ),
          // Divider(
          //   indent: size.width * 0.05,
          // ),
          _buildMenuItem(
            title: locals.touchId,
            icon: Icons.fingerprint,
            onTap: () {},
          ),
          Divider(
            thickness: size.height * 0.02,
          ),
          _buildMenuItem(
            isVisible: true,
            title: locals.logOut,
            icon: Icons.logout_sharp,
            onTap: () async => context.read<AuthCubit>().logout(),
          ),
          // Divider(
          //   indent: size.width * 0.05,
          // ),
          _buildMenuItem(
            title: locals.unregister,
            icon: Icons.delete_forever,
            onTap: () {},
          ),
          Divider(
            thickness: size.height * 0.02,
          ),
          _buildMenuItem(
            isVisible: true,
            title: locals.titleAboutGivt,
            icon: Icons.info,
            onTap: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (_) => AboutGivtBottomSheet(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isVisible = false,
    bool showBadge = false,
  }) =>
      Visibility(
        visible: isVisible,
        child: Column(
          children: [
            ListTile(
              leading: Icon(icon),
              trailing: badges.Badge(
                showBadge: showBadge,
                position: badges.BadgePosition.topStart(top: 6, start: -20),
                child: const Icon(Icons.arrow_forward_ios),
              ),
              title: Text(title),
              onTap: onTap,
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
