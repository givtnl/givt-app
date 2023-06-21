import 'package:flutter/material.dart';

class RegistrationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const RegistrationAppBar({
    super.key,
    this.title,
    this.actions = const [],
    this.leading,
  });

  final Widget? leading;
  final Text? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AppBar(
      leading: leading,
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
