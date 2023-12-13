import 'package:givt_app/l10n/l10n.dart';

mixin ChildDateOfBirthValidator {
  String? validateDateOfBirth({
    required AppLocalizations locals,
    DateTime? dateOfBirth,
  }) {
    String? errorMessage;
    if (dateOfBirth == null) {
      errorMessage = locals.createChildDateErrorText;
    }
    return errorMessage;
  }
}
