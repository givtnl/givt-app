import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';

/// Visual state for [FunInputLabel] (FUN design system — ENG-437).
enum FunInputLabelState {
  defaultState,
  focused,
  filled,
  error,
  disabled,
}

/// Label above FUN inputs: `body/small` typography, token-based color per state.
class FunInputLabel extends StatelessWidget {
  const FunInputLabel({
    required this.text,
    required this.state,
    super.key,
  });

  final String text;
  final FunInputLabelState state;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final color = switch (state) {
      FunInputLabelState.defaultState => theme.neutral40,
      FunInputLabelState.focused => theme.primary60,
      FunInputLabelState.filled => theme.primary40,
      FunInputLabelState.error => theme.error40,
      FunInputLabelState.disabled => theme.neutral70,
    };
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
    );
  }
}

/// Stacks an optional label (4px gap) above [child]. No label → [child] only.
class LabeledField extends StatelessWidget {
  const LabeledField({
    required this.child,
    required this.labelState,
    this.label,
    super.key,
  });

  final String? label;
  final FunInputLabelState labelState;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (label == null || label!.isEmpty) {
      return child;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FunInputLabel(text: label!, state: labelState),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}
