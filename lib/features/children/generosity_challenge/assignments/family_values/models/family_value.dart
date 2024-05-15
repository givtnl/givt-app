import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/enums/area.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/enums/interests.dart';
import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';
import 'package:givt_app/features/give/models/organisation.dart';

class FamilyValue {
  const FamilyValue({
    required this.displayText,
    required this.imagePath,
    required this.colorCombo,
    required this.interestList,
    required this.area,
    required this.organisation,
    required this.orgImagePath,
    required this.collectGroupId,
    required this.longDescription,
  });

  factory FamilyValue.fromMap(Map<String, dynamic> json) {
    return FamilyValue(
      displayText: json['displayText'] as String,
      imagePath: json['imagePath'] as String,
      interestList: List<Interest>.from((json['interestKeys'] as List)
          .map((e) => Interest.fromString(e as String))),
      colorCombo: ColorCombo.values[json['colorCombo'] as int],
      area: Area.fromString(json['area'] as String),
      organisation:
          Organisation.fromJson(json['organisation'] as Map<String, dynamic>),
      orgImagePath: json['orgImagePath'] as String,
      collectGroupId: json['collectGroupId'] as String,
      longDescription: json['longDescription'] as String,
    );
  }
  final String displayText;
  final String imagePath;
  final List<Interest> interestList;
  final ColorCombo colorCombo;
  final Area area;
  final Organisation organisation;
  final String orgImagePath;
  final String collectGroupId;
  final String longDescription;

  Map<String, dynamic> toMap() {
    return {
      'displayText': displayText,
      'imagePath': imagePath,
      'interestKeys': interestList.map((e) => e.value).toList(),
      'colorCombo': ColorCombo.values.indexOf(colorCombo),
      'area': area.value,
      'organisation': organisation.toJson(),
      'orgImagePath': orgImagePath,
      'collectGroupId': collectGroupId,
      'longDescription': longDescription,
    };
  }
}
