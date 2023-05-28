import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';

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
          Container(
            margin: EdgeInsets.only(
              bottom: size.height * 0.02,
            ),
            height: size.height * 0.03,
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: Text(locals.finalizeRegistration),
            onTap: () {},
          ),
          Divider(
            indent: size.width * 0.05,
          ),
          Divider(
            thickness: size.height * 0.03,
          ),
          SizedBox(
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
          Divider(
            thickness: size.height * 0.02,
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: Text(locals.historyTitle),
            onTap: () {},
          ),
          Divider(
            indent: size.width * 0.05,
          ),
          ListTile(
            leading: const Icon(Icons.euro),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: Text(locals.giveLimit),
            onTap: () {},
          ),
          Divider(
            indent: size.width * 0.05,
          ),
          ListTile(
            leading: const Icon(Icons.mode_edit_outlined),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: Text(locals.personalInfo),
            onTap: () {},
          ),
          Divider(
            indent: size.width * 0.05,
          ),
          ListTile(
            leading: const Icon(Icons.settings_input_component),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: Text(locals.amountPresetsTitle),
            onTap: () {},
          ),
          Divider(
            indent: size.width * 0.05,
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline_sharp),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: Text(locals.pincode),
            onTap: () {},
          ),
          Divider(
            indent: size.width * 0.05,
          ),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: Text(locals.touchID),
            onTap: () {},
          ),
          Divider(
            thickness: size.height * 0.02,
          ),
          ListTile(
            leading: const Icon(Icons.logout_sharp),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: Text(locals.logOut),
            onTap: () async => context.read<AuthCubit>().logout(),
          ),
          Divider(
            indent: size.width * 0.05,
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: Text(locals.unregister),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
