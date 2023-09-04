import 'package:equatable/equatable.dart';

class Organisation extends Equatable {
  const Organisation({
    this.campaignId,
    this.organisationName,
    this.country,
    this.organisationLogoLink,
    this.title,
    this.goal,
    this.thankYou,
    this.paymentMethods,
    this.currency,
    this.amounts,
    this.wantKnowMoreLink,
    this.privacyPolicyLink,
    this.mediumId,
  });

  const Organisation.empty()
      : campaignId = '',
        organisationName = '',
        country = '',
        organisationLogoLink = '',
        title = '',
        goal = '',
        thankYou = '',
        paymentMethods = const [],
        currency = '',
        amounts = const [],
        wantKnowMoreLink = '',
        privacyPolicyLink = '',
        mediumId = '';

  factory Organisation.fromJson(Map<String, dynamic> json) => Organisation(
        campaignId: json['campaignId'] as String?,
        organisationName: json.containsKey('orgName')
            ? json['orgName'] as String?
            : json['organisationName'] as String?,
        country: json['country'] as String?,
        organisationLogoLink: json['organisationLogoLink'] as String?,
        title: json['title'] as String?,
        goal: json['goal'] as String?,
        thankYou: json['thankYou'] as String?,
        paymentMethods: json['paymentMethods'] as List<dynamic>?,
        currency: json['currency'] as String?,
        amounts: json['amounts'] as List<dynamic>?,
        wantKnowMoreLink: json['wantKnowMoreLink'] as String?,
        privacyPolicyLink: json['privacyPolicyLink'] as String?,
        mediumId: json.containsKey('mediumId')
            ? json['mediumId'] as String?
            : json['nameSpace'] as String?,
      );

  final String? campaignId;
  final String? organisationName;
  final String? country;
  final String? organisationLogoLink;
  final String? title;
  final String? goal;
  final String? thankYou;
  final List<dynamic>? paymentMethods;
  final String? currency;
  final List<dynamic>? amounts;
  final String? wantKnowMoreLink;
  final String? privacyPolicyLink;
  final String? mediumId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'campaignId': campaignId,
        'organisationName': organisationName,
        'country': country,
        'organisationLogoLink': organisationLogoLink,
        'title': title,
        'goal': goal,
        'thankYou': thankYou,
        'paymentMethods': paymentMethods,
        'currency': currency,
        'amounts': amounts,
        'wantKnowMoreLink': wantKnowMoreLink,
        'privacyPolicyLink': privacyPolicyLink,
        'mediumId': mediumId,
      };

  Organisation copyWith({
    String? campaignId,
    String? organisationName,
    String? country,
    String? organisationLogoLink,
    String? title,
    String? goal,
    String? thankYou,
    List<String>? paymentMethods,
    String? currency,
    List<String>? amounts,
    String? wantKnowMoreLink,
    String? privacyPolicyLink,
    String? mediumId,
  }) {
    return Organisation(
      campaignId: campaignId ?? this.campaignId,
      organisationName: organisationName ?? this.organisationName,
      country: country ?? this.country,
      organisationLogoLink: organisationLogoLink ?? this.organisationLogoLink,
      title: title ?? this.title,
      goal: goal ?? this.goal,
      thankYou: thankYou ?? this.thankYou,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      currency: currency ?? this.currency,
      amounts: amounts ?? this.amounts,
      wantKnowMoreLink: wantKnowMoreLink ?? this.wantKnowMoreLink,
      privacyPolicyLink: privacyPolicyLink ?? this.privacyPolicyLink,
      mediumId: mediumId ?? this.mediumId,
    );
  }

  @override
  List<Object?> get props => [
        campaignId,
        organisationName,
        country,
        organisationLogoLink,
        title,
        goal,
        thankYou,
        paymentMethods,
        currency,
        amounts,
        wantKnowMoreLink,
        privacyPolicyLink,
        mediumId,
      ];

  static const lastOrganisationDonatedKey = 'lastOrganisationDonated';
}
