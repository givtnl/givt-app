import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/areas.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';

class GratitudeTagsData {
  static final tags = [
    const Tag(
      key: 'AFTERADISASTER',
      area: Areas.disaster,
      displayText: 'After a disaster',
      pictureUrl:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/aid.svg',
      type: TagType.INTERESTS,
    ),
    const Tag(
      key: 'CAREFORCHILDREN',
      area: Areas.health,
      displayText: 'Child care',
      pictureUrl:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/children.svg',
      type: TagType.INTERESTS,
    ),
    const Tag(
      key: 'CLEANOCEANS',
      area: Areas.environment,
      displayText: 'Clean oceans',
      pictureUrl:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/ocean.svg',
      type: TagType.INTERESTS,
    ),
    const Tag(
      key: 'FINDAHOME',
      area: Areas.basic,
      displayText: 'Find a home',
      pictureUrl:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/home.svg',
      type: TagType.INTERESTS,
    ),
    const Tag(
      key: 'GETFOOD',
      area: Areas.basic,
      displayText: 'Get food',
      pictureUrl:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/food.svg',
      type: TagType.INTERESTS,
    ),
    const Tag(
      key: 'GOTOSCHOOL',
      area: Areas.education,
      displayText: 'Go to school',
      pictureUrl:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/school.svg',
      type: TagType.INTERESTS,
    ),
    const Tag(
      key: 'LEARNTOREAD',
      area: Areas.education,
      displayText: 'Learn to read',
      pictureUrl:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/learn.svg',
      type: TagType.INTERESTS,
    ),
    const Tag(
      key: 'PROTECTANIMALS',
      area: Areas.environment,
      displayText: 'Protect animals',
      pictureUrl:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/panda.svg',
      type: TagType.INTERESTS,
    ),
    const Tag(
      key: 'PROTECTFORESTS',
      area: Areas.environment,
      displayText: 'Protect forests',
      pictureUrl:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/tree.svg',
      type: TagType.INTERESTS,
    ),
    const Tag(
      key: 'STAYHEALTHY',
      area: Areas.health,
      displayText: 'Stay healthy',
      pictureUrl:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/healthy.svg',
      type: TagType.INTERESTS,
    ),
    const Tag(
      key: 'THATAREHOMELESS',
      area: Areas.basic,
      displayText: 'Houseless',
      pictureUrl:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/homeless.svg',
      type: TagType.INTERESTS,
    ),
    const Tag(
      key: 'WITHDISABILITIES',
      area: Areas.health,
      displayText: 'Disabilities',
      pictureUrl:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/disabilities.svg',
      type: TagType.INTERESTS,
    ),
  ];
  static final gratitudeCategories = [
    const GratitudeCategory(
      colorCombo: ColorCombo.highlight,
      displayText: 'People',
      iconData: FontAwesomeIcons.peopleGroup,
      tags: [
        Tag(
          key: 'AFTERADISASTER',
          area: Areas.disaster,
          displayText: 'After a disaster',
          pictureUrl:
              'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/aid.svg',
          type: TagType.INTERESTS,
        ),
        Tag(
          key: 'CAREFORCHILDREN',
          area: Areas.health,
          displayText: 'Child care',
          pictureUrl:
              'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/children.svg',
          type: TagType.INTERESTS,
        ),
      ],
    ),
    const GratitudeCategory(
      colorCombo: ColorCombo.primary,
      displayText: 'Nature',
      iconData: FontAwesomeIcons.tree,
      tags: [
        Tag(
          key: 'CLEANOCEANS',
          area: Areas.environment,
          displayText: 'Clean oceans',
          pictureUrl:
              'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/ocean.svg',
          type: TagType.INTERESTS,
        ),
        Tag(
          key: 'PROTECTANIMALS',
          area: Areas.environment,
          displayText: 'Protect animals',
          pictureUrl:
              'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/panda.svg',
          type: TagType.INTERESTS,
        ),
        Tag(
          key: 'PROTECTFORESTS',
          area: Areas.environment,
          displayText: 'Protect forests',
          pictureUrl:
              'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/tree.svg',
          type: TagType.INTERESTS,
        ),
      ],
    ),
    const GratitudeCategory(
      colorCombo: ColorCombo.secondary,
      displayText: 'Learning',
      iconData: FontAwesomeIcons.graduationCap,
      tags: [
        Tag(
          key: 'GOTOSCHOOL',
          area: Areas.education,
          displayText: 'Go to school',
          pictureUrl:
              'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/school.svg',
          type: TagType.INTERESTS,
        ),
        Tag(
          key: 'LEARNTOREAD',
          area: Areas.education,
          displayText: 'Learn to read',
          pictureUrl:
              'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/learn.svg',
          type: TagType.INTERESTS,
        ),
      ],
    ),
    const GratitudeCategory(
      colorCombo: ColorCombo.highlight,
      displayText: 'Healthy',
      iconData: FontAwesomeIcons.heartPulse,
      tags: [
        Tag(
          key: 'STAYHEALTHY',
          area: Areas.health,
          displayText: 'Stay healthy',
          pictureUrl:
              'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/healthy.svg',
          type: TagType.INTERESTS,
        ),
        Tag(
          key: 'GETFOOD',
          area: Areas.basic,
          displayText: 'Get food',
          pictureUrl:
              'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/food.svg',
          type: TagType.INTERESTS,
        ),
      ],
    ),
    const GratitudeCategory(
      colorCombo: ColorCombo.tertiary,
      displayText: 'Home',
      iconData: FontAwesomeIcons.house,
      tags: [
        Tag(
          key: 'THATAREHOMELESS',
          area: Areas.basic,
          displayText: 'Houseless',
          pictureUrl:
              'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/homeless.svg',
          type: TagType.INTERESTS,
        ),
        Tag(
          key: 'FINDAHOME',
          area: Areas.basic,
          displayText: 'Find a home',
          pictureUrl:
              'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/home.svg',
          type: TagType.INTERESTS,
        ),
      ],
    ),
    const GratitudeCategory(
      colorCombo: ColorCombo.secondary,
      displayText: 'Help',
      iconData: FontAwesomeIcons.handshakeAngle,
      tags: [
        Tag(
          key: 'WITHDISABILITIES',
          area: Areas.health,
          displayText: 'Disabilities',
          pictureUrl:
              'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/disabilities.svg',
          type: TagType.INTERESTS,
        ),
        Tag(
          key: 'AFTERADISASTER',
          area: Areas.disaster,
          displayText: 'After a disaster',
          pictureUrl:
              'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/aid.svg',
          type: TagType.INTERESTS,
        ),
      ],
    ),
  ];
}
