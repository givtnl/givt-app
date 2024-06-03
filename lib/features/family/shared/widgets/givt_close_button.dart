import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:givt_app/features/family/shared/widgets/action_container.dart';
import 'package:go_router/go_router.dart';

class GivtCloseButton extends StatelessWidget {
  const GivtCloseButton({
    super.key,
    this.isDisabled = false,
  });

  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      borderColor: Theme.of(context).colorScheme.primaryContainer,
      baseBorderSize: 4,
      base: ActionContainerBase.bottom,
      isDisabled: isDisabled,
      onTap: () => context.pop(),
      child: Container(
        width: 40,
        height: 40,
        color: isDisabled ? AppTheme.disabledTileBorder : Colors.white,
        child: Icon(
          FontAwesomeIcons.xmark,
          size: 20,
          color: Theme.of(context)
              .colorScheme
              .onPrimaryContainer
              .withOpacity(isDisabled ? 0.5 : 1),
        ),
      ),
    );
  }
}
