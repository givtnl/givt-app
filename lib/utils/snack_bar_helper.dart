import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showMessage(
    BuildContext context, {
    required String text,
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }
}
