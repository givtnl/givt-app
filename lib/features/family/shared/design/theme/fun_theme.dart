import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_app_theme.dart';
import 'package:givt_app/features/family/shared/design/tokens/fun_givt_tokens.dart';

/// Access the current [FunAppTheme] from the widget tree.
/// Use [FunTheme.of] so the active theme (Givt or Givt4Kids) drives colors.
class FunTheme {
  FunTheme._();

  /// Returns the [FunAppTheme] extension from [context], or [fallback] if not found.
  /// When no extension is present (e.g. tests), defaults to [FunGivtTheme].
  static FunAppTheme of(BuildContext context, {FunAppTheme? fallback}) {
    final theme = Theme.of(context);
    final extension = theme.extension<FunAppTheme>();
    return extension ?? fallback ?? _defaultTheme;
  }

  static final FunAppTheme _defaultTheme = FunAppTheme(tokens: FunGivtTokens.instance);
}
