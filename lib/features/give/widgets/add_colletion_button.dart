import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/utils/utils.dart';

class AddCollectionButton extends StatelessWidget {
  const AddCollectionButton({
    required this.onPressed,
    required this.label,
    super.key,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
      ),
      child: Center(
        child: DottedBorder(
          color: AppTheme.givtLightPurple,
          strokeCap: StrokeCap.round,
          dashPattern: const [3, 6],
          borderPadding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          borderType: BorderType.RRect,
          radius: const Radius.circular(6),
          padding: const EdgeInsets.all(6),
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.add_circle_outlined),
            label: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: AppTheme.givtLightPurple,
              backgroundColor: Colors.transparent,
              minimumSize: const Size(50, 40),
            ),
          ),
        ),
      ),
    );
  }
}
