import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';
import 'package:givt_app/shared/widgets/action_container.dart';
import 'package:givt_app/utils/app_theme.dart';

class DayButton extends StatelessWidget {
  const DayButton({
    required this.isCompleted,
    required this.isActive,
    required this.dayIndex,
    required this.onPressed,
    this.onLongPressed,
    super.key,
  });

  final bool isActive;
  final bool isCompleted;
  final int dayIndex;
  final VoidCallback onPressed;
  final VoidCallback? onLongPressed;

  @override
  Widget build(BuildContext context) {
    final isLocked = !isActive && !isCompleted;
    return GestureDetector(
      onLongPress: !isLocked && kDebugMode ? onLongPressed : null,
      child: ActionContainer(
        isMuted: isLocked,
        isSelected: isCompleted || isLocked,
        borderColor: isActive || isCompleted
            ? ColorCombo.values[dayIndex % ColorCombo.values.length].borderColor
            : AppTheme.neutralVariant80,
        onTap: onPressed,
        child: ColoredBox(
          color: isActive || isCompleted
              ? ColorCombo
                  .values[dayIndex % ColorCombo.values.length].backgroundColor
              : AppTheme.neutralVariant90,
          child: Stack(
            children: [
              Center(
                child: Text(
                  'Day ${dayIndex + 1}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isActive || isCompleted
                        ? ColorCombo.values[dayIndex % ColorCombo.values.length]
                            .textColor
                        : AppTheme.neutralVariant50,
                    fontSize: 20,
                    fontFamily: 'Rouna',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isCompleted)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.primary70,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(4),
                      ),
                    ),
                    child: const Icon(
                      FontAwesomeIcons.check,
                      color: AppTheme.primary40,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
