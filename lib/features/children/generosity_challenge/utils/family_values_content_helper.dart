import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/enums/area.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/enums/interests.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';
import 'package:givt_app/features/give/models/organisation.dart';

class FamilyValuesContentHelper {
  static const String devCollectGroupId =
      '0728DEEF-CA95-4F4B-9C6F-08DB6B55109D';
  static const String devMediumId = 'NjFmN2VkMDE1NTUzMDYyM2IwMDA=';

  static final List<FamilyValue> _values = [
    const FamilyValue(
      displayText: 'Everyone deserves\nhelp from disaster',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/aid.svg',
      colorCombo: ColorCombo.highlight,
      interestList: [Interest.afterDisaster],
      area: Area.disaster,
      orgImagePath:
          'https://givtstorageus.blob.core.windows.net/public/cdn/pog-logos/89DECA05-8677-45F7-AEBE-21A8771FF939_Action.png',
      collectGroupId: '89deca05-8677-45f7-aebe-21a8771ff939',
      longDescription:
          'Crime Prevention Network is a group of people who want to make our city safer. They teach us how to stay safe and prevent crimes from happening. They work with the police and other important people to make sure everyone knows how to protect themselves. They have special programs to help us learn about being alert, reporting crimes, and escaping safely if we need to. Their goal is to make our community a better and safer place for everyone.',
      organisation: Organisation(
        organisationName: 'Crime Commission Inc',
        mediumId: 'NjFmN2VkMDE1NTUzMTEyM2QwNTE=',
        currency: 'USD',
        organisationLogoLink:
            'https://givtstorageus.blob.core.windows.net/public/cdn/pog-logos/89DECA05-8677-45F7-AEBE-21A8771FF939.png',
      ),
    ),
    const FamilyValue(
      displayText: 'Everyone has a part\nto keep children safe',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/children.svg',
      colorCombo: ColorCombo.tertiary,
      interestList: [Interest.careForChildren],
      area: Area.health,
      collectGroupId: '36ec728e-9b9f-4232-843a-038a4a7bf946',
      longDescription:
          "New Hope Oklahoma is a charity that helps kids whose parents are in prison. They want to make sure these kids don't feel alone or scared, and they want to help them have a good future. They do this by having fun activities after school, on weekends, during holidays, and in the summer. They create a safe and friendly place where these kids can feel happy and supported.",
      orgImagePath:
          'https://givtstorageus.blob.core.windows.net/public/cdn/pog-logos/36EC728E-9B9F-4232-843A-038A4A7BF946_Action.png',
      organisation: Organisation(
        organisationName: 'New Hope Oklahoma',
        mediumId: 'NjFmN2VkMDE1NTUzMTEyM2QwMGQ=',
        currency: 'USD',
        organisationLogoLink:
            'https://givtstorageus.blob.core.windows.net/public/cdn/pog-logos/36EC728E-9B9F-4232-843A-038A4A7BF946.png',
      ),
    ),
    const FamilyValue(
      displayText: 'Everyone deserves\na chance to learn',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/learn.svg',
      colorCombo: ColorCombo.secondary,
      interestList: [Interest.learnToRead, Interest.goToSchool],
      area: Area.education,
      collectGroupId: '454591DB-163E-4509-BFE6-07B97C168A87',
      longDescription:
          'The Tulsa Library Trust is a group of people who want to help everyone in Tulsa County learn and grow. They do this by making sure the library has lots of great books, fun programs, and helpful services for people of all ages. They also give awards to really good books and authors. The Trust wants to make sure that everyone in Tulsa County has the chance to read, learn, and become the best they can be.',
      orgImagePath:
          'https://givtstorageus.blob.core.windows.net/public/cdn/pog-logos/454591DB-163E-4509-BFE6-07B97C168A87_Action.png',
      organisation: Organisation(
        organisationName: 'Tulsa Library Trust',
        mediumId: 'NjFmN2VkMDE1NTUzMTEyM2QwMTA=',
        currency: 'USD',
        organisationLogoLink:
            'https://givtstorageus.blob.core.windows.net/public/cdn/pog-logos/454591DB-163E-4509-BFE6-07B97C168A87.png',
      ),
    ),
    const FamilyValue(
      displayText: 'Everyone has a duty\nto protect animals',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/panda.svg',
      colorCombo: ColorCombo.primary,
      interestList: [Interest.protectAnimals],
      area: Area.environment,
      collectGroupId: '946F6389-BEED-4D2D-9783-DDE61510CD5B',
      longDescription:
          'Great Plains Land and Wildlife Conservation Corporation is a group of people who work really hard to take care of the land, water, and animals in the United States. They want to make sure that the beautiful places and the animals that live there are protected for a long, long time. They also respect and appreciate the people who have been taking care of these places for a very long time. Their goal is to make sure that kids like you and your friends can enjoy these special places and animals when you grow up too.',
      orgImagePath:
          'https://givtstorageus.blob.core.windows.net/public/cdn/pog-logos/946F6389-BEED-4D2D-9783-DDE61510CD5B_Action.png',
      organisation: Organisation(
        organisationName:
            'Great Plains Land And Wildlife Conservation Corporation',
        mediumId: 'NjFmN2VkMDE1NTUzMTEyM2QwNWY=',
        currency: 'USD',
        organisationLogoLink:
            'https://givtstorageus.blob.core.windows.net/public/cdn/pog-logos/946F6389-BEED-4D2D-9783-DDE61510CD5B.png',
      ),
    ),
    const FamilyValue(
      displayText: 'Everyone should be able\nto live a healthy life',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/healthy.svg',
      colorCombo: ColorCombo.tertiary,
      interestList: [Interest.stayHealthy, Interest.withDisabilities],
      area: Area.health,
      collectGroupId: '3EBDE99F-877E-40ED-A1A3-072AE332F1AD',
      longDescription:
          ' Trinity Woods is a place where older people can live happily and get the help they need. They have nice homes, good food, and doctors to take care of them. They also make sure that the seniors feel loved and happy by giving them lots of kindness and support. Trinity Woods has been doing this for a long time and they always try to make life better for older people.',
      orgImagePath:
          'https://givtstorageus.blob.core.windows.net/public/cdn/pog-logos/946F6389-BEED-4D2D-9783-DDE61510CD5B_Action.png',
      organisation: Organisation(
        organisationName: 'Oklahoma Methodist Manor Inc',
        mediumId: 'NjFmN2VkMDE1NTUzMTEyM2QwNjc=',
        currency: 'USD',
        organisationLogoLink:
            'https://givtstorageus.blob.core.windows.net/public/cdn/pog-logos/3EBDE99F-877E-40ED-A1A3-072AE332F1AD.png',
      ),
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
      collectGroupId: 'B347C7B4-D846-417C-9ACC-82F7964FD602',
      longDescription:
          "Food on the Move, Inc is a charity that helps people who live in places where it's hard to find healthy food. They want to make sure everyone has access to good food, even if they live in areas where it's difficult to find. They also want to fix problems that have been around for a long time and make sure everyone has enough to eat.",
      orgImagePath:
          'https://givtstorageus.blob.core.windows.net/public/cdn/pog-logos/B347C7B4-D846-417C-9ACC-82F7964FD602_Action.png',
      organisation: Organisation(
        organisationName: 'Food on The Move Inc',
        mediumId: 'NjFmN2VkMDE1NTUzMTEyM2QwMDk=',
        currency: 'USD',
        organisationLogoLink:
            'https://givtstorageus.blob.core.windows.net/public/cdn/pog-logos/B347C7B4-D846-417C-9ACC-82F7964FD602.png',
      ),
    ),
    const FamilyValue(
      displayText: 'Everyone has a duty\nto care for our environment',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/tree.svg',
      colorCombo: ColorCombo.primary,
      interestList: [Interest.protectForests],
      area: Area.environment,
      collectGroupId: '81B009DC-F18C-455A-8381-81138466BB68',
      longDescription:
          'Up With Trees is a group of people who love trees and want to make our city, Tulsa, a better place to live. They plant and take care of trees in public places like parks and streets. They also teach people about how trees help the environment, make us healthier, and make our city more beautiful. They need help from kind people who want to make Tulsa greener and better for everyone.',
      orgImagePath:
          'https://givtstorageus.blob.core.windows.net/public/cdn/pog-logos/81B009DC-F18C-455A-8381-81138466BB68_Action.png',
      organisation: Organisation(
        organisationName: 'Up with Trees',
        mediumId: 'NjFmN2VkMDE1NTUzMTEyM2QwMTg=',
        currency: 'USD',
        organisationLogoLink:
            'https://givtstorageus.blob.core.windows.net/public/cdn/pog-logos/81B009DC-F18C-455A-8381-81138466BB68.png',
      ),
    ),
  ];

  static List<FamilyValue> get values => _values;
}
