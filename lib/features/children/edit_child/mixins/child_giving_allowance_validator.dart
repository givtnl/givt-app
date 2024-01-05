import 'package:givt_app/l10n/l10n.dart';

mixin ChildGivingAllowanceValidator {
  static const num _minAllowance = 1.0;

  String? validateGivingAllowance({
    required AppLocalizations locals,
    num? allowance,
  }) {
    String? errorMessage;

    if ((allowance ?? 0) < _minAllowance) {
      errorMessage = locals.createChildAllowanceErrorText;
    }

    return errorMessage;
  }
}
