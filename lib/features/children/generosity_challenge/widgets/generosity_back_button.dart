import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class GenerosityBackButton extends StatelessWidget {
  const GenerosityBackButton({
    super.key,
    this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? context.pop,
      icon: const Icon(FontAwesomeIcons.arrowLeft),
      iconSize: 24,
      color: AppTheme.primary30,
    );
  }
}
