import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/enums/area.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/enums/interests.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';

class FamilyValuesContentHelper {
  static final List<FamilyValue> _values = [
    const FamilyValue(
      displayText: 'Everyone deserves\nhelp from disaster',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/aid.svg',
      colorCombo: ColorCombo.highlight,
      interestList: [Interest.afterDisaster],
      area: Area.disaster,
    ),
    const FamilyValue(
      displayText: 'Everyone has a part\nto keep children safe',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/children.svg',
      colorCombo: ColorCombo.tertiary,
      interestList: [Interest.careForChildren],
      area: Area.health,
    ),
    const FamilyValue(
      displayText: 'Everyone deserves\na chance to learn',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/learn.svg',
      colorCombo: ColorCombo.secondary,
      interestList: [Interest.learnToRead, Interest.goToSchool],
      area: Area.education,
    ),
    const FamilyValue(
      displayText: 'Everyone has a duty\nto protect animals',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/panda.svg',
      colorCombo: ColorCombo.primary,
      interestList: [Interest.protectAnimals],
      area: Area.environment,
    ),
    const FamilyValue(
      displayText: 'Everyone should be able\nto live a healthy life',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/healthy.svg',
      colorCombo: ColorCombo.tertiary,
      interestList: [Interest.stayHealthy, Interest.withDisabilities],
      area: Area.health,
    ),
    const FamilyValue(
      displayText: 'Everyone needs a\nhome and food',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/food.svg',
      colorCombo: ColorCombo.highlight,
      interestList: [
        Interest.findAHome,
        Interest.getFood,
        Interest.thatAreHomeless
      ],
      area: Area.basic,
    ),
    const FamilyValue(
      displayText: 'Everyone has a duty\nto care for our environment',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/tree.svg',
      colorCombo: ColorCombo.primary,
      interestList: [Interest.protectForests],
      area: Area.environment,
    ),
  ];

  static List<FamilyValue> get values => _values;
}
