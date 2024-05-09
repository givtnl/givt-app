import 'package:flutter/material.dart';
import 'package:givt_app/shared/widgets/action_container.dart';
import 'package:givt_app/utils/utils.dart';

class GivtIconButton extends StatelessWidget {
  const GivtIconButton({
    required this.iconData,
    required this.onTap,
    super.key,
    this.isDisabled = false,
  });

  final IconData iconData;
  final void Function() onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      borderColor: AppTheme.givtGreen40,
      borderSize: 0.1,
      baseBorderSize: 4,
      isDisabled: isDisabled,
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        color: isDisabled ? AppTheme.givtGraycece : AppTheme.primary80,
        child: Icon(
          iconData,
          size: 30,
          color: isDisabled
              ? Theme.of(context).colorScheme.outline
              : AppTheme.givtGreen40,
        ),
      ),
    );
  }
}
