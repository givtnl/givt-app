import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = AppLocalizations.of(context);

    return Drawer(
      child: ListView(
        children: [
          _buildGivtLogo(size),
          _buildMenuItem(
            title: locals.finalizeRegistration,
            icon: Icons.edit,
            onTap: () {},
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
            title: locals.touchID,
            icon: Icons.fingerprint,
            onTap: () {},
          ),
          // Divider(
          //   thickness: size.height * 0.02,
          // ),
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
          Center(
            child: FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }
                final packageInfo = snapshot.data!;
                return Text(
                  'v${packageInfo.version}.${packageInfo.buildNumber}',
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isVisible = false,
  }) =>
      Visibility(
        visible: isVisible,
        child: Column(
          children: [
            ListTile(
              leading: Icon(icon),
              trailing: const Icon(Icons.arrow_forward_ios),
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
