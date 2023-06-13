import 'package:flutter/material.dart';

class RegistrationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const RegistrationAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AppBar(
      leading: const BackButton(),
      title: Image.asset(
        'assets/images/logo.png',
        height: size.height * 0.04,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.question_mark_outlined),
          onPressed: () {
            ///todo add faq here
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
