import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';

// A widget that only shows when an error occurs in the app that we can't recover from.
class UnrecoverableError extends StatelessWidget {
  const UnrecoverableError({
    this.testString,
    super.key,
  });

  final String? testString;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          (kDebugMode && testString?.isNotEmpty == true)
              ? testString!
              : context.l10n.somethingWentWrong,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
