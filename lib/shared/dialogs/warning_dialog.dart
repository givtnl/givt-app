import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class WarningDialog extends StatelessWidget {
  const WarningDialog({
    required this.title,
    required this.content,
    this.onConfirm,
    this.actions,
    super.key,
  });

  final String title;
  final String content;
  final VoidCallback? onConfirm;
  final List<CupertinoDialogAction>? actions;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions ??
          [
            CupertinoDialogAction(
              onPressed: onConfirm ?? () => context.pop(),
              child: const Text('Ok'),
            ),
          ],
    );
  }
}
