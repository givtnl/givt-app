import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';

/// A stepper widget that displays progress through multiple steps.
///
/// The [currentStep] is zero-indexed, meaning the first step is 0,
/// the second step is 1, and so on.
class FunStepper extends StatelessWidget {
  const FunStepper({
    required this.stepCount,
    required this.currentStep,
    super.key,
  });

  /// The total number of steps in the stepper
  final int stepCount;

  /// The current step (zero-indexed)
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(stepCount, (index) {
        return Container(
          width: 56,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: index <= currentStep
                ? FunTheme.of(context).primary70
                : FunTheme.of(context).neutral90,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
