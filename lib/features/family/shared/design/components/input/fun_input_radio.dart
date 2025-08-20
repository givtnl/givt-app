import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FunInputRadio extends StatelessWidget {
  const FunInputRadio({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: FamilyAppTheme.primary20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            _CustomRadio(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _CustomRadio extends StatelessWidget {
  const _CustomRadio({required this.isSelected});
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? FamilyAppTheme.primary40
              : FamilyAppTheme.primary20,
          width: 2,
        ),
        color: Colors.transparent,
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: FamilyAppTheme.primary40,
                ),
              ),
            )
          : null,
    );
  }
}
