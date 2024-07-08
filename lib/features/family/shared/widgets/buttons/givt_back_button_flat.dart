import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class GivtBackButtonFlat extends StatelessWidget {
  const GivtBackButtonFlat({
    super.key,
    this.onPressedExt,
    this.color,
  });

  final void Function()? onPressedExt;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: FaIcon(
        FontAwesomeIcons.arrowLeft,
        color: color ?? AppTheme.primary20,
      ),
      onPressed: () {
        SystemSound.play(SystemSoundType.click);
        onPressedExt?.call();
        context.pop();
      },
    );
  }
}
