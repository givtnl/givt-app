import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({
    required this.onTryAgain,
    required this.onCancel,
    required this.title,
    required this.content,
    super.key,
  });

  final String title;
  final String content;
  final VoidCallback onTryAgain;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(locals.cancel),
        ),
        TextButton(
          onPressed: onTryAgain,
          child: Text(locals.tryAgain),
        ),
      ],
    );
  }
}
