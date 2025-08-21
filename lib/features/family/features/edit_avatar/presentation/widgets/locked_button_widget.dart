import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

class LockedButtonWidget extends StatelessWidget {
  const LockedButtonWidget({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      borderColor: FamilyAppTheme.neutralVariant80,
      onTap: onPressed,
      analyticsEvent: AmplitudeEvents.lockedButtonClicked.toEvent(),
      child: const ColoredBox(
        color: FamilyAppTheme.neutral98,
        child: Center(
          child: FaIcon(
            FontAwesomeIcons.lock,
            color: FamilyAppTheme.neutralVariant60,
            size: 32,
          ),
        ),
      ),
    );
  }
}
