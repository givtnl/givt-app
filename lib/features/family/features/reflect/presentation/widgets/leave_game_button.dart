import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_dialog.dart';

class LeaveGameButton extends StatelessWidget {
  const LeaveGameButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const FaIcon(FontAwesomeIcons.xmark),
      onPressed: () {
        const LeaveGameDialog().show(context);
      },
    );
  }
}
