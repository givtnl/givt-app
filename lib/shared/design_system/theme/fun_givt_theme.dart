import 'package:givt_app/shared/design_system/theme/fun_app_theme.dart';
import 'package:givt_app/shared/design_system/tokens/fun_givt_tokens.dart';

/// Givt app theme (green primary, Onest font).
/// Use [FunGivtTheme().toThemeData()] for the main Givt app.
class FunGivtTheme extends FunAppTheme {
  FunGivtTheme() : super(tokens: FunGivtTokens.instance);
}
