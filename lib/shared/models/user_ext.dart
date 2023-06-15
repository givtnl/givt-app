import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/enums.dart';

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
    this.countryCode = -1,
    this.isGiftAidEnabled = false,
    this.accountType = AccountType.none,
    this.appLanguage = '',
  });

  factory UserExt.empty() => const UserExt(
        email: '',
        guid: '',
        amountLimit: 0,
      );

  factory UserExt.fromJson(Map<String, dynamic> json) => UserExt(
        email: json['Email'] as String,
        guid: json['GUID'] as String,
        amountLimit: json['AmountLimit'] as int,
        tempUser: json['IsTempUser'] as bool,
        iban: json['IBAN'] as String,
        phoneNumber: json['PhoneNumber'] as String,
        firstName: json['FirstName'] as String,
        lastName: json['LastName'] as String,
        address: json['Address'] as String,
        postalCode: json['PostalCode'] as String,
        city: json['City'] as String,
        country: json['Country'] as String,
        countryCode: json['CountryCode'] as int,
        isGiftAidEnabled: json['GiftAidEnabled'] as bool,
        appLanguage: json['AppLanguage'] as String?,
        accountType: AccountType.fromString(json['AccountType'] as String),
      );

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
        'mandateSigned': mandateSigned,
        'maxAmountRegistered': maxAmountRegistered,
        'multipleCollectsFirstBallon': multipleCollectsFirstBallon,
        'multipleCollectsSecondBallon': multipleCollectsSecondBallon,
        'needRegistration': needRegistration,
        'personalInfoRegistered': personalInfoRegistered,
        'pinSet': pinSet,
        'multipleCollectsAccepted': multipleCollectsAccepted,
      };

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
  final bool isGiftAidEnabled;
  final AccountType accountType;
  final String? appLanguage;

  final bool tempUser;
  final bool mandateSigned;
  final bool maxAmountRegistered;
  final bool multipleCollectsFirstBallon;

  final bool multipleCollectsSecondBallon;
  final bool needRegistration;
  final bool personalInfoRegistered;

  final bool pinSet;

  final bool multipleCollectsAccepted;

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
    AccountType? accountType,
    String? appLanguage,
    int? amountLimit,
    bool? tempUser,
    bool? mandateSigned,
    bool? maxAmountRegistered,
    bool? multipleCollectsFirstBallon,
    bool? multipleCollectsSecondBallon,
    bool? needRegistration,
    bool? personalInfoRegistered,
    bool? pinSet,
    bool? multipleCollectsAccepted,
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
      personalInfoRegistered:
          personalInfoRegistered ?? this.personalInfoRegistered,
      pinSet: pinSet ?? this.pinSet,
      multipleCollectsAccepted:
          multipleCollectsAccepted ?? this.multipleCollectsAccepted,
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
        isGiftAidEnabled,
        accountType,
        appLanguage,
        tempUser,
        mandateSigned,
        maxAmountRegistered,
        multipleCollectsFirstBallon,
        multipleCollectsSecondBallon,
        needRegistration,
        personalInfoRegistered,
        pinSet,
        multipleCollectsAccepted,
      ];

  static String tag = 'UserExt';
}
