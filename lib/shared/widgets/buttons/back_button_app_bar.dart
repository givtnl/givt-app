import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class BackButtonAppBar extends StatelessWidget {
  const BackButtonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        FontAwesomeIcons.arrowLeft,
      ),
      onPressed: () {
        context.pop();
      },
    );
  }
}
