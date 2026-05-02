import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/utils/fun_theme_legacy.dart';

/// EU-style scaffold: applies FUN legacy theme, dismisses keyboard on tap, and
/// pads [body] with [SafeArea] using [minimumPadding].
///
/// **Padding:** By default [minimumPadding] is `24, 24, 24, 40` (LTRB). Treat
/// that as the standard screen inset—do **not** add another full-width
/// `Padding` or `SingleChildScrollView` padding with the same horizontal/bottom
/// values on [body], or content will be double-indented. Use spacing *between*
/// widgets ([SizedBox], section padding inside cards, etc.) instead.
///
/// For edge-to-edge layouts, pass [minimumPadding]: `EdgeInsets.zero` (and
/// [withSafeArea]: `false` if appropriate) and handle insets explicitly.
///
/// [floatingActionButton] is additionally wrapped with horizontal padding `24`.
class FunScaffold extends StatelessWidget {
  const FunScaffold({
    required this.body,
    this.appBar,
    this.minimumPadding = const EdgeInsets.fromLTRB(24, 24, 24, 40),
    this.canPop = true,
    this.safeAreaBottom = true,
    this.withSafeArea = true,
    this.floatingActionButton,
    this.backgroundColor = Colors.white,
    this.onPopInvokedWithResult,
    super.key,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;

  /// Minimum inset applied around [body] via [SafeArea] (merged with device
  /// safe areas). Default matches standard FUN screen margins.
  final EdgeInsets minimumPadding;
  final bool canPop;
  final bool safeAreaBottom;
  final bool withSafeArea;
  final Color backgroundColor;
  final FunButton? floatingActionButton;

  /// Same contract as [PopScope.onPopInvokedWithResult] (result type is loose).
  final PopInvokedWithResultCallback<Object?>? onPopInvokedWithResult;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: const FamilyAppTheme().toThemeData(),
      child: GestureDetector(
        // Dismiss keyboard on tap
        onTap: () => FocusScope.of(context).unfocus(),
        child: PopScope(
          canPop: canPop,
          onPopInvokedWithResult: onPopInvokedWithResult,
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: appBar,
            body: withSafeArea
                ? SafeArea(
                    minimum: minimumPadding,
                    bottom: safeAreaBottom,
                    child: body,
                  )
                : body,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: floatingActionButton,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          ),
        ),
      ),
    );
  }
}
