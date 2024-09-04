import 'package:flutter/material.dart';
import 'package:givt_app/shared/widgets/givt_tabs.dart';

class ChildOrParentSelector extends StatelessWidget {
  const ChildOrParentSelector({
    required this.selections,
    required this.onPressed,
    super.key,
  });
  final List<bool> selections;
  final void Function(int) onPressed;
  @override
  Widget build(BuildContext context) {
    return GivtTabs(
        selections: selections,
        onPressed: onPressed,
        firstOption: 'Child',
        secondOption: 'Parent');
  }
}
