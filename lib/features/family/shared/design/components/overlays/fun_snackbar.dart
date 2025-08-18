import 'dart:async';
import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_medium_text.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FunSnackbar {
  static OverlayEntry? _currentSnackbar;
  static Timer? _timer;

  static void show(
    BuildContext context, {
    required String message,
    Widget? icon,
    Duration duration = const Duration(milliseconds: 5000),
  }) {
    _removeCurrent();
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        left: 16,
        right: 16,
        bottom: 32 + MediaQuery.of(context).viewInsets.bottom + 80,
        child: _FunSnackbarContent(
          message: message,
          icon: icon,
        ),
      ),
    );
    overlay.insert(entry);
    _currentSnackbar = entry;
    _timer = Timer(duration, _removeCurrent);
  }

  static void _removeCurrent() {
    _timer?.cancel();
    _timer = null;
    _currentSnackbar?.remove();
    _currentSnackbar = null;
  }
}

class _FunSnackbarContent extends StatelessWidget {
  const _FunSnackbarContent({
    required this.message,
    this.icon,
  });

  final String message;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const ValueKey('FunSnackbar'),
      direction: DismissDirection.down,
      onDismissed: (_) => FunSnackbar._removeCurrent(),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: FamilyAppTheme.primary95,
            borderRadius: BorderRadius.circular(16),
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
                child: TitleMediumText(
                  message,
                  color: FamilyAppTheme.primary30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FunSnackbarWidget extends StatelessWidget {
  const FunSnackbarWidget({
    super.key,
    required this.message,
    this.icon,
  });

  final String message;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return _FunSnackbarContent(message: message, icon: icon);
  }
}
