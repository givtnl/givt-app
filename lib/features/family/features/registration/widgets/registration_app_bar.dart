import 'package:flutter/material.dart';

class RegistrationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const RegistrationAppBar({
    super.key,
    this.title,
    this.actions = const [],
    this.leading,
    this.isUS = false,
  });

  final Widget? leading;
  final Text? title;
  final List<Widget>? actions;
  final bool isUS;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AppBar(
      automaticallyImplyLeading: !isUS,
      leading: isUS ? null : leading,
      title: title ??
          Image.asset(
            'assets/images/logo.png',
            height: size.height * 0.03,
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
