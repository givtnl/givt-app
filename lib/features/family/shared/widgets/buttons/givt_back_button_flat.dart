import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class GivtBackButtonFlat extends StatelessWidget {
  const GivtBackButtonFlat({
    super.key,
    this.onPressed,
    this.onPressedExt,
    this.color,
  });

  /// Extend the onPressed function
  final Future<void> Function()? onPressedExt;

  /// Override the entire onPressed function
  final Future<void> Function()? onPressed;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: 'backButton',
      child: IconButton(
        icon: FaIcon(
          FontAwesomeIcons.arrowLeft,
          color: color ?? FunTheme.of(context).primary20,
        ),
        onPressed: onPressed ??
            () async {
              unawaited(AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.backButtonPressed,
              ));

              unawaited(SystemSound.play(SystemSoundType.click));
              await onPressedExt?.call();
              if (context.mounted) {
                context.pop();
              }
            },
      ),
    );
  }
}
