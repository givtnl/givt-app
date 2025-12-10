import 'dart:async';
import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

/// This is a class that is used to display a snackbar as (temporary) overlay.
class FunSnackbar {
  static OverlayEntry? _currentSnackbar;
  static Timer? _timer;

  static void show(
    BuildContext context, {
    String? title,
    String? extraText,
    Widget? icon,
    Duration duration = const Duration(milliseconds: 5000),
  }) {
    _removeCurrent();
    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        left: 24,
        right: 24,
        bottom: 32 + MediaQuery.of(context).viewInsets.bottom + 80,
        child: _FunSnackbarContent(
          title: title,
          extraText: extraText,
          icon: icon,
        ),
      ),
    );
    overlay.insert(entry);
    _currentSnackbar = entry;
    _timer = Timer(duration, _removeCurrent);
  }

  /// Removes the current snackbar if one is displayed
  static void removeCurrent() {
    _removeCurrent();
  }

  static void _removeCurrent() {
    _timer?.cancel();
    _timer = null;
    _currentSnackbar?.remove();
    _currentSnackbar = null;
  }
}

/// This is a widget that is used to display a snackbar as static widget.
class FunSnackbarWidget extends StatelessWidget {
  const FunSnackbarWidget({
    this.title,
    this.extraText,
    this.icon,
    super.key,
  });

  final String? title;
  final String? extraText;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return _FunSnackbarContent(title: title, extraText: extraText, icon: icon);
  }
}

class _FunSnackbarContent extends StatelessWidget {
  const _FunSnackbarContent({
    this.title,
    this.extraText,
    this.icon,
  });

  final String? title;
  final String? extraText;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const ValueKey('FunSnackbar'),
      direction: DismissDirection.down,
      onDismissed: (_) => FunSnackbar._removeCurrent(),
      child: Material(
        color: Colors.transparent,
        child: Theme(
          data: const FamilyAppTheme().toThemeData(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: FamilyAppTheme.secondary95,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null) LabelMediumText.secondary30(title!),
                      if (extraText != null)
                        BodySmallText.secondary30(extraText!),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
