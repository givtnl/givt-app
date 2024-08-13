import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/utils/utils.dart';

class UserExt extends Equatable {
  const UserExt({
    required this.email,
    required this.guid,
    required this.amountLimit,
    this.tempUser = false,
    this.mandateSigned = false,
    this.maxAmountRegistered = false,
    this.multipleCollectsFirstBallon = true,
    this.multipleCollectsSecondBallon = true,
    this.needRegistration = true,
    this.isInvitedUser = false,
    this.personalInfoRegistered = false,
    this.pinSet = false,
    this.multipleCollectsAccepted = false,
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.address = '',
    this.postalCode = '',
    this.city = '',
    this.country = '',
    this.iban = '',
    this.payProvMandate = '',
    this.payProvMandateStatus = '',
    this.countryCode = -1,
    this.isGiftAidEnabled = false,
    this.accountType = AccountType.none,
    this.appLanguage = '',
    this.sortCode = '',
    this.accountNumber = '',
    this.accountBrand = '',
    this.notificationId = '',
    this.profilePicture = '',
  });

  factory UserExt.fromJson(Map<String, dynamic> json) {
    final isInvitedUser = json['FirstName'] != Util.defaultFirstName &&
        json['LastName'] == Util.defaultLastName &&
        json['PhoneNumber'] == Util.defaultPhoneNumber;
    final personalInfoRegistered = (json['LastName'] != Util.defaultLastName ||
            json['FirstName'] != Util.defaultFirstName) &&
        !isInvitedUser;

    return UserExt(
      email: json['Email'] as String,
      guid: (json['GUID'] ?? json['Guid']) as String,
      amountLimit: json['AmountLimit'] as int,
      tempUser: (json['IsTempUser'] ?? json['TempUser']) as bool,
      iban: json['IBAN'] != null ? json['IBAN'] as String : '',
      phoneNumber: (json['PhoneNumber'] ?? '') as String,
      firstName: (json['FirstName'] ?? '') as String,
      lastName: (json['LastName'] ?? '') as String,
      address: (json['Address'] ?? '') as String,
      postalCode: (json['PostalCode'] ?? '') as String,
      city: (json['City'] ?? '') as String,
      country: (json['Country'] ?? '') as String,
      countryCode: (json['CountryCode'] ?? -1) as int,
      isGiftAidEnabled: (json['GiftAidEnabled'] ?? false) as bool,
      sortCode: (json['SortCode'] ?? '') as String,
      accountNumber: (json['AccountNumber'] ?? '') as String,
      accountBrand: (json['AccountBrand'] ?? '') as String,
      appLanguage: (json['AppLanguage'] ?? '') as String,
      accountType:
          AccountType.fromString((json['AccountType'] ?? '') as String),
      needRegistration: (json['IsTempUser'] ?? json['TempUser']) as bool,
      isInvitedUser: isInvitedUser,
      personalInfoRegistered: personalInfoRegistered,
      payProvMandateStatus: (json['PayProvMandateStatus'] ?? '') as String,
      payProvMandate: json['PayProvMandate'] != null
          ? json['PayProvMandate'] as String
          : '',
      mandateSigned: json.containsKey('mandateSigned')
          ? json['mandateSigned'] as bool
          : json['PayProvMandateStatus'] == 'closed.completed',
      notificationId: json['PushNotificationId'] != null
          ? json['PushNotificationId'] as String
          : '',
      profilePicture: (json['ProfilePicture'] ?? '').toString(),
    );
  }

  const UserExt.empty()
      : email = '',
        guid = '',
        amountLimit = 0,
        tempUser = false,
        mandateSigned = false,
        maxAmountRegistered = false,
        multipleCollectsFirstBallon = true,
        multipleCollectsSecondBallon = true,
        needRegistration = true,
        isInvitedUser = false,
        personalInfoRegistered = false,
        pinSet = false,
        multipleCollectsAccepted = false,
        firstName = '',
        lastName = '',
        phoneNumber = '',
        address = '',
        postalCode = '',
        city = '',
        country = '',
        iban = '',
        payProvMandate = '',
        payProvMandateStatus = '',
        countryCode = -1,
        isGiftAidEnabled = false,
        accountType = AccountType.none,
        appLanguage = '',
        sortCode = '',
        accountNumber = '',
        accountBrand = '',
        notificationId = '',
        profilePicture = '';

  bool get isUsUser => Country.fromCode(country).isUS;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'Email': email,
        'GUID': guid,
        'AmountLimit': amountLimit,
        'IsTempUser': tempUser,
        'IBAN': iban,
        'PhoneNumber': phoneNumber,
        'FirstName': firstName,
        'LastName': lastName,
        'Address': address,
        'PostalCode': postalCode,
        'City': city,
        'Country': country,
        'CountryCode': countryCode,
        'IsGiftAidEnabled': isGiftAidEnabled,
        'AccountType': accountType.toString(),
        'GiftAidEnabled': isGiftAidEnabled,
        'AppLanguage': appLanguage,
        'SortCode': sortCode,
        'AccountNumber': accountNumber,
        'AccountBrand': accountBrand,
        'PushNotificationId': notificationId,
        'mandateSigned': mandateSigned,
        'maxAmountRegistered': maxAmountRegistered,
        'multipleCollectsFirstBallon': multipleCollectsFirstBallon,
        'multipleCollectsSecondBallon': multipleCollectsSecondBallon,
        'needRegistration': needRegistration,
        'isInvitedUser': isInvitedUser,
        'personalInfoRegistered': personalInfoRegistered,
        'pinSet': pinSet,
        'multipleCollectsAccepted': multipleCollectsAccepted,
        'ProfilePicture': profilePicture,
      };

  Map<String, dynamic> toUpdateJson() {
    final json = <String, dynamic>{};
    json['id'] = guid;
    if (iban.isNotEmpty) json['iban'] = iban;
    if (phoneNumber.isNotEmpty) json['phoneNumber'] = phoneNumber;
    if (sortCode.isNotEmpty) json['sortCode'] = sortCode;
    if (accountNumber.isNotEmpty) json['accountNumber'] = accountNumber;

    json['address'] = address;
    json['postalCode'] = postalCode;
    json['city'] = city;
    json['country'] = country;

    return json;
  }

  final String email;
  final String guid;
  final int amountLimit;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final int countryCode;
  final String iban;
  final String sortCode;
  final String accountNumber;
  final String accountBrand;
  final String payProvMandateStatus;
  final String payProvMandate;

  final bool isGiftAidEnabled;
  final AccountType accountType;
  final String? appLanguage;
  final String notificationId;

  final bool tempUser;
  final bool mandateSigned;
  final bool maxAmountRegistered;
  final bool multipleCollectsFirstBallon;

  final bool multipleCollectsSecondBallon;
  final bool needRegistration;
  final bool isInvitedUser;
  final bool personalInfoRegistered;

  final bool pinSet;

  final bool multipleCollectsAccepted;

  final String profilePicture;

  UserExt copyWith({
    String? email,
    String? guid,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? address,
    String? city,
    String? postalCode,
    String? country,
    int? countryCode,
    String? iban,
    bool? isGiftAidEnabled,
    String? sortCode,
    String? accountNumber,
    String? accountBrand,
    AccountType? accountType,
    String? appLanguage,
    String? payProvMandateStatus,
    String? payProvMandate,
    String? notificationId,
    int? amountLimit,
    bool? tempUser,
    bool? mandateSigned,
    bool? maxAmountRegistered,
    bool? multipleCollectsFirstBallon,
    bool? multipleCollectsSecondBallon,
    bool? needRegistration,
    bool? isInvitedUser,
    bool? personalInfoRegistered,
    bool? pinSet,
    bool? multipleCollectsAccepted,
    String? profilePicture,
  }) {
    return UserExt(
      email: email ?? this.email,
      guid: guid ?? this.guid,
      amountLimit: amountLimit ?? this.amountLimit,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      iban: iban ?? this.iban,
      sortCode: sortCode ?? this.sortCode,
      accountNumber: accountNumber ?? this.accountNumber,
      accountBrand: accountBrand ?? this.accountBrand,
      isGiftAidEnabled: isGiftAidEnabled ?? this.isGiftAidEnabled,
      appLanguage: appLanguage ?? this.appLanguage,
      accountType: accountType ?? this.accountType,
      tempUser: tempUser ?? this.tempUser,
      mandateSigned: mandateSigned ?? this.mandateSigned,
      maxAmountRegistered: maxAmountRegistered ?? this.maxAmountRegistered,
      multipleCollectsFirstBallon:
          multipleCollectsFirstBallon ?? this.multipleCollectsFirstBallon,
      multipleCollectsSecondBallon:
          multipleCollectsSecondBallon ?? this.multipleCollectsSecondBallon,
      needRegistration: needRegistration ?? this.needRegistration,
      isInvitedUser: isInvitedUser ?? this.isInvitedUser,
      personalInfoRegistered:
          personalInfoRegistered ?? this.personalInfoRegistered,
      pinSet: pinSet ?? this.pinSet,
      multipleCollectsAccepted:
          multipleCollectsAccepted ?? this.multipleCollectsAccepted,
      // notificationId: notificationId ?? this.notificationId,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  @override
  List<Object?> get props => [
        email,
        guid,
        amountLimit,
        firstName,
        lastName,
        phoneNumber,
        address,
        city,
        postalCode,
        country,
        countryCode,
        iban,
        sortCode,
        accountNumber,
        accountBrand,
        isGiftAidEnabled,
        accountType,
        appLanguage,
        tempUser,
        mandateSigned,
        maxAmountRegistered,
        multipleCollectsFirstBallon,
        multipleCollectsSecondBallon,
        needRegistration,
        isInvitedUser,
        personalInfoRegistered,
        pinSet,
        multipleCollectsAccepted,
        // notificationId,
        profilePicture,
      ];

  static String tag = 'UserExt';

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'UserExt{tempUser: $tempUser, needRegistration: $needRegistration, mandateSigned: $mandateSigned}';
  }
}
