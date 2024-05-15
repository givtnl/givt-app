import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/enums/area.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/enums/interests.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';
import 'package:givt_app/features/give/models/organisation.dart';

class FamilyValuesContentHelper {
  static final List<FamilyValue> _values = [
    const FamilyValue(
      displayText: 'Everyone deserves\nhelp from disaster',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/aid.svg',
      colorCombo: ColorCombo.highlight,
      interestList: [Interest.afterDisaster],
      area: Area.disaster,
      organisation: Organisation(
          organisationName: 'Crime Commission Inc',
          mediumId: 'NjFmN2VkMDE1NTUzMTEyM2QwNTE=',
          campaignId: '89deca05-8677-45f7-aebe-21a8771ff939',
          currency: 'USD',
          organisationLogoLink:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/LEGO_logo.svg/1024px-LEGO_logo.svg.png'),
      orgImagePath:
          'https://cdn.shopify.com/s/files/1/0015/5117/1636/files/Bunny_outside.jpg?v=1687550353',
      devOrganisation: Organisation(
        organisationName: 'Crime Commission Inc',
        mediumId: 'NjFmN2VkMDE1NTUzMTEyM2QwNTE=',
        campaignId: '89deca05-8677-45f7-aebe-21a8771ff939',
        currency: 'USD',
      ),
    ),
    const FamilyValue(
      displayText: 'Everyone has a part\nto keep children safe',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/children.svg',
      colorCombo: ColorCombo.tertiary,
      interestList: [Interest.careForChildren],
      area: Area.health,
      organisation: Organisation(
        organisationName: 'New Hope Oklahoma',
        mediumId: '',
        campaignId: '',
        currency: 'USD',
        organisationLogoLink:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/LEGO_logo.svg/1024px-LEGO_logo.svg.png',
      ),
      orgImagePath:
          'https://cdn.shopify.com/s/files/1/0015/5117/1636/files/Bunny_outside.jpg?v=1687550353',
      devOrganisation: Organisation(
        organisationName: 'Crime Commission Inc',
        mediumId: 'NjFmN2VkMDE1NTUzMTEyM2QwNTE=',
        campaignId: '89deca05-8677-45f7-aebe-21a8771ff939',
        currency: 'USD',
        organisationLogoLink:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/LEGO_logo.svg/1024px-LEGO_logo.svg.png',
      ),
    ),
    const FamilyValue(
      displayText: 'Everyone deserves\na chance to learn',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/learn.svg',
      colorCombo: ColorCombo.secondary,
      interestList: [Interest.learnToRead, Interest.goToSchool],
      area: Area.education,
      organisation: Organisation(
        organisationName: 'Tulsa Library Trust',
        mediumId: '',
        currency: 'USD',
        organisationLogoLink:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/LEGO_logo.svg/1024px-LEGO_logo.svg.png',
      ),
      orgImagePath:
          'https://cdn.shopify.com/s/files/1/0015/5117/1636/files/Bunny_outside.jpg?v=1687550353',
      devOrganisation: Organisation(
        organisationName: 'Crime Commission Inc',
        mediumId: 'NjFmN2VkMDE1NTUzMTEyM2QwNTE=',
        campaignId: '89deca05-8677-45f7-aebe-21a8771ff939',
        currency: 'USD',
        organisationLogoLink:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/LEGO_logo.svg/1024px-LEGO_logo.svg.png',
      ),
    ),
    const FamilyValue(
      displayText: 'Everyone has a duty\nto protect animals',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/panda.svg',
      colorCombo: ColorCombo.primary,
      interestList: [Interest.protectAnimals],
      area: Area.environment,
      organisation: Organisation(
        organisationName:
            'Great Plains Land And Wildlife Conservation Corporation',
        mediumId: '',
        currency: 'USD',
        organisationLogoLink:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/LEGO_logo.svg/1024px-LEGO_logo.svg.png',
      ),
      orgImagePath:
          'https://cdn.shopify.com/s/files/1/0015/5117/1636/files/Bunny_outside.jpg?v=1687550353',
      devOrganisation: Organisation(
        organisationName: 'Crime Commission Inc',
        mediumId: 'NjFmN2VkMDE1NTUzMTEyM2QwNTE=',
        campaignId: '89deca05-8677-45f7-aebe-21a8771ff939',
        currency: 'USD',
        organisationLogoLink:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/LEGO_logo.svg/1024px-LEGO_logo.svg.png',
      ),
    ),
    const FamilyValue(
      displayText: 'Everyone should be able\nto live a healthy life',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/healthy.svg',
      colorCombo: ColorCombo.tertiary,
      interestList: [Interest.stayHealthy, Interest.withDisabilities],
      area: Area.health,
      organisation: Organisation(
        organisationName: 'Oklahoma Methodist Manor Inc',
        mediumId: '',
        currency: 'USD',
        organisationLogoLink:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/LEGO_logo.svg/1024px-LEGO_logo.svg.png',
      ),
      orgImagePath:
          'https://cdn.shopify.com/s/files/1/0015/5117/1636/files/Bunny_outside.jpg?v=1687550353',
      devOrganisation: Organisation(
        organisationName: 'Crime Commission Inc',
        mediumId: 'NjFmN2VkMDE1NTUzMTEyM2QwNTE=',
        campaignId: '89deca05-8677-45f7-aebe-21a8771ff939',
        currency: 'USD',
        organisationLogoLink:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/LEGO_logo.svg/1024px-LEGO_logo.svg.png',
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
      organisation: Organisation(
        organisationName: 'Food on The Move Inc',
        mediumId: '',
        currency: 'USD',
        organisationLogoLink:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/LEGO_logo.svg/1024px-LEGO_logo.svg.png',
      ),
      orgImagePath:
          'https://cdn.shopify.com/s/files/1/0015/5117/1636/files/Bunny_outside.jpg?v=1687550353',
      devOrganisation: Organisation(
        organisationName: 'Crime Commission Inc',
        mediumId: 'NjFmN2VkMDE1NTUzMTEyM2QwNTE=',
        campaignId: '89deca05-8677-45f7-aebe-21a8771ff939',
        currency: 'USD',
        organisationLogoLink:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/LEGO_logo.svg/1024px-LEGO_logo.svg.png',
      ),
    ),
    const FamilyValue(
      displayText: 'Everyone has a duty\nto care for our environment',
      imagePath:
          'https://givtstoragedebug.blob.core.windows.net/public/cdn/tag-logos/tree.svg',
      colorCombo: ColorCombo.primary,
      interestList: [Interest.protectForests],
      area: Area.environment,
      organisation: Organisation(
        organisationName: 'Up with Trees',
        mediumId: '',
        currency: 'USD',
        organisationLogoLink:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/LEGO_logo.svg/1024px-LEGO_logo.svg.png',
      ),
      orgImagePath:
          'https://cdn.shopify.com/s/files/1/0015/5117/1636/files/Bunny_outside.jpg?v=1687550353',
      devOrganisation: Organisation(
        organisationName: 'Crime Commission Inc',
        mediumId: 'NjFmN2VkMDE1NTUzMTEyM2QwNTE=',
        campaignId: '89deca05-8677-45f7-aebe-21a8771ff939',
        currency: 'USD',
        organisationLogoLink:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/LEGO_logo.svg/1024px-LEGO_logo.svg.png',
      ),
    ),
  ];

  static List<FamilyValue> get values => _values;
}
