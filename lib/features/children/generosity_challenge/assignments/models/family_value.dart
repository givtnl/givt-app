import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';

class FamilyValue {
  const FamilyValue({
    required this.displayText,
    required this.imagePath,
    required this.colorCombo,
    required this.interestKeys,
    required this.area,
  });

  final String displayText;
  final String imagePath;
  final List<String> interestKeys;
  final ColorCombo colorCombo;
  final String area;
}
