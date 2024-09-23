import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/finish_reflection_dialog.dart';

class FinishReflectingButton extends StatelessWidget {
  const FinishReflectingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const FaIcon(FontAwesomeIcons.xmark),
      onPressed: () {
        const FinishReflectionDialog().show(context);
      },
    );
  }
}
