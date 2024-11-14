import 'package:givt_app/core/enums/country.dart';

class EmailSignupUiModel {
  const EmailSignupUiModel({
    required this.email,
    required this.country,
    required this.continueButtonEnabled,
  });

  final String email;
  final Country country;
  final bool continueButtonEnabled;
}
