import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';

class FamilyValue {
  const FamilyValue({
    required this.displayText,
    required this.imagePath,
    required this.colorCombo,
    required this.interestKeys,
    required this.area,
  });

  factory FamilyValue.fromJson(Map<String, dynamic> json) {
    return FamilyValue(
      displayText: json['displayText'] as String,
      imagePath: json['imagePath'] as String,
      interestKeys: List<String>.from(json['interestKeys'] as List<dynamic>),
      colorCombo: ColorCombo.values[json['colorCombo'] as int],
      area: json['area'] as String,
    );
  }
  final String displayText;
  final String imagePath;
  final List<String> interestKeys;
  final ColorCombo colorCombo;
  final String area;

  Map<String, dynamic> toJson() {
    return {
      'displayText': displayText,
      'imagePath': imagePath,
      'interestKeys': interestKeys.map((e) => '"$e"').toList(),
      'colorCombo': ColorCombo.values.indexOf(colorCombo),
      'area': area
    };
  }
}
