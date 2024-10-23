import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/warning_dialog.dart';
import 'package:go_router/go_router.dart';

class InternetConnectionLostDialog {
  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => WarningDialog(
        title: context.l10n.noInternetConnectionTitle,
        content:
            "Oops! It looks like you're not connected to the internet. Some features might not work as expected. Please come back when you have a connection.",
        onConfirm: () => context.pop(),
      ),
    );
  }
}
