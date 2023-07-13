import 'package:flutter/cupertino.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.confirmText,
    required this.cancelText,
    required this.onCancel,
    super.key,
  });

  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          onPressed: onConfirm,
          child: Text(confirmText),
        ),
        CupertinoDialogAction(
          onPressed: onCancel,
          child: Text(cancelText),
        ),
      ],
    );
  }
}
