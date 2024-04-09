import 'package:flutter/material.dart';

class DayItemPlaceholder extends StatelessWidget {
  const DayItemPlaceholder({
    required this.isCompleted,
    required this.isActive,
    required this.dayIndex,
    required this.onPressed,
    super.key,
  });

  final bool isActive;
  final bool isCompleted;
  final int dayIndex;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isActive && !isCompleted ? onPressed : null,
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: Colors.grey,
      ),
      child: Text(
        'Day ${dayIndex + 1}${isCompleted ? '\n(done)' : ''}',
        textAlign: TextAlign.center,
      ),
    );
  }
}
