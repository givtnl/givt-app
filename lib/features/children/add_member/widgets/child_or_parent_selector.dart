import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_medium_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/utils/utils.dart';

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
    return ToggleButtons(
      borderWidth: 2,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      borderColor: AppTheme.inputFieldBorderEnabled,
      selectedBorderColor: FamilyAppTheme.primary80,
      selectedColor: Colors.white,
      fillColor: FamilyAppTheme.primary80,
      color: FamilyAppTheme.primary80,
      constraints: BoxConstraints(
        minHeight: 40,
        minWidth: MediaQuery.of(context).size.width / 2 - 60,
      ),
      isSelected: selections,
      onPressed: onPressed,
      children: const [
        LabelMediumText('Child'),
        LabelMediumText('Parent'),
      ],
    );
  }
}
