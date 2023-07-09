import 'package:flutter/cupertino.dart';

class WarningDialog extends StatelessWidget {
  const WarningDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    super.key,
  });

  final String title;
  final String content;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          onPressed: onConfirm,
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
