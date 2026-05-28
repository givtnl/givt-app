import 'package:givt_app/shared/design_system/theme/fun_app_theme.dart';
import 'package:givt_app/shared/design_system/tokens/fun_givt4kids_tokens.dart';

/// Givt4Kids / family app theme (teal primary, Rouna font).
/// Use [FunGivt4KidsTheme().toThemeData()] for the family app.
class FunGivt4KidsTheme extends FunAppTheme {
  FunGivt4KidsTheme() : super(tokens: FunGivt4KidsTokens.instance);
}
