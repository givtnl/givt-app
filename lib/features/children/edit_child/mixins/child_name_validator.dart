import 'package:givt_app/l10n/l10n.dart';

mixin ChildNameValidator {
  static const int nameMinLength = 3;
  static const int nameMaxLength = 20;

  String? validateName({
    required AppLocalizations locals,
    String? name,
  }) {
    String? errorMessage;
    final trimmedName = name != null ? name.trim() : '';

    if (trimmedName.length < nameMinLength) {
      errorMessage =
          '${locals.createChildNameErrorTextFirstPart1}$nameMinLength${locals.createChildNameErrorTextFirstPart2}';
    }
    return errorMessage;
  }
}
