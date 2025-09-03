import 'package:equatable/equatable.dart';

class WebViewInput extends Equatable {
  const WebViewInput({
    this.advertisementImageUrl = '',
    this.nativeAppScheme = 'givt://',
    this.yesSuccess = '',
    this.thanks = '',
    this.close = '',
    this.guid = '',
    this.collect = '',
    this.confirmBtn = '',
    this.currency = '',
    this.isProduction = false,
    this.canShare = false,
    this.shouldShowCreditCard = false,
    this.slimPayInformationPart2 = '',
    this.advertisementText = '',
    this.slimPayInformation = '',
    this.organisation = '',
    this.shareGivt = '',
    this.urlPart = 'natived',
    this.spUrl = '',
    this.cancel = '',
    this.message = '',
    this.areYouSureToCancelGivts = '',
    this.advertisementTitle = '',
    this.apiUrl = '',
    this.givtObj = const [],
    this.experiencePoints,
    this.subtotalText = '',
    this.totalText = '',
    this.platformFeeNoContributionText = '',
    this.platformFeeGoodOptionText = '',
    this.platformFeeCommonOptionText = '',
    this.platformFeeGenerousOptionText = '',
    this.platformFeeText = '',
    this.platformFeeTitle = '',
    this.platformFeePlaceholder = '',
    this.platformFeeRequired = '',
    this.transactionIds = const [],
  });

  factory WebViewInput.fromJson(Map<String, dynamic> json) => WebViewInput(
        advertisementImageUrl: json['advertisementImageUrl'] as String,
        nativeAppScheme: json['nativeAppScheme'] as String,
        yesSuccess: json['YesSuccess'] as String,
        thanks: json['Thanks'] as String,
        close: json['Close'] as String,
        guid: json['GUID'] as String,
        collect: json['Collect'] as String,
        confirmBtn: json['ConfirmBtn'] as String,
        currency: json['currency'] as String,
        isProduction: json['isProduction'] as bool,
        canShare: json['canShare'] as bool,
        shouldShowCreditCard: json['shouldShowCreditCard'] as bool,
        slimPayInformationPart2: json['SlimPayInformationPart2'] as String,
        advertisementText: json['advertisementText'] as String,
        slimPayInformation: json['SlimPayInformation'] as String,
        organisation: json['organisation'] as String,
        shareGivt: json['ShareGivt'] as String,
        urlPart: json['urlPart'] as String,
        spUrl: json['spUrl'] as String,
        cancel: json['Cancel'] as String,
        message: json['message'] as String,
        areYouSureToCancelGivts: json['areYouSureToCancelGivts'] as String,
        advertisementTitle: json['advertisementTitle'] as String,
        apiUrl: json['apiUrl'] as String,
        givtObj: json['givtObj'] as List<Map<String, dynamic>>,
        experiencePoints: json['experiencePoints'] as int?,
        subtotalText: json['subtotalText'] as String,
        totalText: json['totalText'] as String,
        platformFeeNoContributionText: json['platformFeeNoContributionText'] as String,
        platformFeeGoodOptionText: json['platformFeeGoodOptionText'] as String,
        platformFeeCommonOptionText: json['platformFeeCommonOptionText'] as String,
        platformFeeGenerousOptionText: json['platformFeeGenerousOptionText'] as String,
        platformFeeText: json['platformFeeText'] as String,
        platformFeeTitle: json['platformFeeTitle'] as String,
        transactionIds: json['transactionIds'] as List<int>,
      );

  final String advertisementImageUrl;
  final String nativeAppScheme;
  final String yesSuccess;
  final String thanks;
  final String close;
  final String guid;
  final String collect;
  final String confirmBtn;
  final String currency;
  final bool isProduction;
  final bool canShare;
  final bool shouldShowCreditCard;
  final String slimPayInformationPart2;
  final String advertisementText;
  final String slimPayInformation;
  final String organisation;
  final String shareGivt;
  final String urlPart;
  final String spUrl;
  final String cancel;
  final String message;
  final String areYouSureToCancelGivts;
  final String advertisementTitle;
  final String apiUrl;
  final List<Map<String, dynamic>> givtObj;
  final int? experiencePoints;
  final String subtotalText;
  final String totalText;
  final String platformFeeNoContributionText;
  final String platformFeeGoodOptionText;
  final String platformFeeCommonOptionText;
  final String platformFeeGenerousOptionText;
  final String platformFeeText;
  final String platformFeeTitle;
  final String platformFeePlaceholder;
  final String platformFeeRequired;
  final List<int> transactionIds;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'advertisementImageUrl': advertisementImageUrl,
        'nativeAppScheme': nativeAppScheme,
        'YesSuccess': yesSuccess,
        'Thanks': thanks,
        'Close': close,
        'GUID': guid,
        'Collect': collect,
        'ConfirmBtn': confirmBtn,
        'currency': currency,
        'isProduction': isProduction,
        'canShare': canShare,
        'shouldShowCreditCard': shouldShowCreditCard,
        'SlimPayInformationPart2': slimPayInformationPart2,
        'advertisementText': advertisementText,
        'SlimPayInformation': slimPayInformation,
        'organisation': organisation,
        'ShareGivt': shareGivt,
        'urlPart': urlPart,
        'spUrl': spUrl,
        'Cancel': cancel,
        'message': message,
        'AreYouSureToCancelGivts': areYouSureToCancelGivts,
        'advertisementTitle': advertisementTitle,
        'apiUrl': apiUrl,
        'givtObj': givtObj,
        'experiencePoints': experiencePoints,
        'subtotalText': subtotalText,
        'totalText': totalText,
        'platformFeeNoContributionText': platformFeeNoContributionText,
        'platformFeeGoodOptionText': platformFeeGoodOptionText,
        'platformFeeCommonOptionText': platformFeeCommonOptionText,
        'platformFeeGenerousOptionText': platformFeeGenerousOptionText,
        'platformFeeText': platformFeeText,
        'platformFeeTitle': platformFeeTitle,
        'platformFeePlaceholder': platformFeePlaceholder,
        'platformFeeRequired': platformFeeRequired,
        'transactionIds': transactionIds,
      };

  WebViewInput copyWith({
    String? advertisementImageUrl,
    String? nativeAppScheme,
    String? yesSuccess,
    String? thanks,
    String? close,
    String? guid,
    String? collect,
    String? confirmBtn,
    String? currency,
    bool? isProduction,
    bool? canShare,
    bool? shouldShowCreditCard,
    String? slimPayInformationPart2,
    String? advertisementText,
    String? slimPayInformation,
    String? organisation,
    String? shareGivt,
    String? urlPart,
    String? spUrl,
    String? cancel,
    String? message,
    String? areYouSureToCancelGivts,
    String? advertisementTitle,
    String? apiUrl,
    List<Map<String, dynamic>>? givtObj,
    int? experiencePoints,
    String? subtotalText,
    String? totalText,
    String? platformFeeNoContributionText,
    String? platformFeeGoodOptionText,
    String? platformFeeCommonOptionText,
    String? platformFeeGenerousOptionText,
    String? platformFeeText,
    String? platformFeeTitle,
    String? platformFeePlaceholder,
    String? platformFeeRequired,
    List<int>? transactionIds,
  }) {
    return WebViewInput(
      advertisementImageUrl:
          advertisementImageUrl ?? this.advertisementImageUrl,
      nativeAppScheme: nativeAppScheme ?? this.nativeAppScheme,
      yesSuccess: yesSuccess ?? this.yesSuccess,
      thanks: thanks ?? this.thanks,
      close: close ?? this.close,
      guid: guid ?? this.guid,
      collect: collect ?? this.collect,
      confirmBtn: confirmBtn ?? this.confirmBtn,
      currency: currency ?? this.currency,
      isProduction: isProduction ?? this.isProduction,
      canShare: canShare ?? this.canShare,
      shouldShowCreditCard: shouldShowCreditCard ?? this.shouldShowCreditCard,
      slimPayInformationPart2:
          slimPayInformationPart2 ?? this.slimPayInformationPart2,
      advertisementText: advertisementText ?? this.advertisementText,
      slimPayInformation: slimPayInformation ?? this.slimPayInformation,
      organisation: organisation ?? this.organisation,
      shareGivt: shareGivt ?? this.shareGivt,
      urlPart: urlPart ?? this.urlPart,
      spUrl: spUrl ?? this.spUrl,
      cancel: cancel ?? this.cancel,
      message: message ?? this.message,
      areYouSureToCancelGivts:
          areYouSureToCancelGivts ?? this.areYouSureToCancelGivts,
      advertisementTitle: advertisementTitle ?? this.advertisementTitle,
      apiUrl: apiUrl ?? this.apiUrl,
      givtObj: givtObj ?? this.givtObj,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      subtotalText: subtotalText ?? this.subtotalText,
      totalText: totalText ?? this.totalText,
      platformFeeNoContributionText: platformFeeNoContributionText ?? this.platformFeeNoContributionText,
      platformFeeGoodOptionText: platformFeeGoodOptionText ?? this.platformFeeGoodOptionText,
      platformFeeCommonOptionText: platformFeeCommonOptionText ?? this.platformFeeCommonOptionText,
      platformFeeGenerousOptionText: platformFeeGenerousOptionText ?? this.platformFeeGenerousOptionText,
      platformFeeText: platformFeeText ?? this.platformFeeText,
      platformFeeTitle: platformFeeTitle ?? this.platformFeeTitle,
      platformFeePlaceholder: platformFeePlaceholder ?? this.platformFeePlaceholder,
      platformFeeRequired: platformFeeRequired ?? this.platformFeeRequired,
      transactionIds: transactionIds ?? this.transactionIds,
    );
  }

  @override
  List<Object?> get props => [
        advertisementImageUrl,
        nativeAppScheme,
        yesSuccess,
        thanks,
        close,
        guid,
        collect,
        confirmBtn,
        currency,
        isProduction,
        canShare,
        shouldShowCreditCard,
        slimPayInformationPart2,
        advertisementText,
        slimPayInformation,
        organisation,
        shareGivt,
        urlPart,
        spUrl,
        cancel,
        message,
        areYouSureToCancelGivts,
        advertisementTitle,
        apiUrl,
        givtObj,
        experiencePoints,
        subtotalText,
        totalText,
        platformFeeNoContributionText,
        platformFeeGoodOptionText,
        platformFeeCommonOptionText,
        platformFeeGenerousOptionText,
        platformFeeText,
        platformFeeTitle,
        platformFeePlaceholder,
        platformFeeRequired,
        transactionIds,
      ];
}
