import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/design_system/theme/fun_theme_legacy.dart';

/// Variant types for the snackbar
enum FunSnackbarVariant {
  /// Info variant with secondary colors
  info,
  /// Success variant with primary colors
  success,
  /// Alert variant with highlight (yellow) colors; used for persistent inline banners
  alert,
}

/// This is a class that is used to display a snackbar as (temporary) overlay.
class FunSnackbar {
  static OverlayEntry? _currentSnackbar;
  static Timer? _timer;

  static void show(
    BuildContext context, {
    String? title,
    String? extraText,
    Widget? icon,
    FunSnackbarVariant variant = FunSnackbarVariant.info,
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
          variant: variant,
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

/// Persistent inline snackbar widget — same layout as the overlay, without dismiss behaviour.
class FunSnackbarWidget extends StatelessWidget {
  const FunSnackbarWidget({
    this.title,
    this.extraText,
    this.icon,
    this.variant = FunSnackbarVariant.info,
    super.key,
  });

  final String? title;
  final String? extraText;
  final Widget? icon;
  final FunSnackbarVariant variant;

  @override
  Widget build(BuildContext context) {
    return _FunSnackbarContent(
      title: title,
      extraText: extraText,
      icon: icon,
      variant: variant,
      persistent: true,
    );
  }
}

class _FunSnackbarContent extends StatelessWidget {
  const _FunSnackbarContent({
    this.title,
    this.extraText,
    this.icon,
    this.variant = FunSnackbarVariant.info,
    this.persistent = false,
  });

  final String? title;
  final String? extraText;
  final Widget? icon;
  final FunSnackbarVariant variant;
  /// When true the Dismissible wrapper is omitted (use for inline persistent banners).
  final bool persistent;

  Color get _backgroundColor => switch (variant) {
        FunSnackbarVariant.info => FamilyAppTheme.secondary95,
        FunSnackbarVariant.success => FamilyAppTheme.primary95,
        FunSnackbarVariant.alert => FamilyAppTheme.highlight95,
      };

  Color get _textColor => switch (variant) {
        FunSnackbarVariant.info => FamilyAppTheme.secondary30,
        FunSnackbarVariant.success => FamilyAppTheme.primary30,
        FunSnackbarVariant.alert => FamilyAppTheme.highlight30,
      };

  @override
  Widget build(BuildContext context) {
    final body = Material(
      color: Colors.transparent,
      child: Theme(
        data: const FamilyAppTheme().toThemeData(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: _backgroundColor,
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    if (title != null)
                      LabelMediumText(
                        title!,
                        color: _textColor,
                      ),
                    if (extraText != null)
                      BodySmallText(
                        extraText!,
                        color: _textColor,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (persistent) return body;

    return Dismissible(
      key: const ValueKey('FunSnackbar'),
      direction: DismissDirection.down,
      onDismissed: (_) => FunSnackbar._removeCurrent(),
      child: body,
    );
  }
}

/// Helper widget to create a circle-check icon for success snackbars
class CircleCheckIcon extends StatelessWidget {
  const CircleCheckIcon({
    super.key,
    this.size = 24,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: FamilyAppTheme.primary50,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.check,
          size: size * 0.5,
          color: Colors.white,
        ),
      ),
    );
  }
}
