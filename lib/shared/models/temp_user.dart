import 'package:equatable/equatable.dart';
import 'package:givt_app/utils/util.dart';

class TempUser extends Equatable {
  const TempUser({
    required this.email,
    required this.iban,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.password,
    required this.amountLimit,
    required this.appLanguage,
    required this.timeZoneId,
    required this.accountNumber,
    required this.sortCode,
    this.guid,
  });

  factory TempUser.empty() => const TempUser(
        email: '',
        iban: '',
        phoneNumber: '',
        firstName: '',
        lastName: '',
        address: '',
        city: '',
        postalCode: '',
        country: '',
        password: '',
        amountLimit: 0,
        appLanguage: '',
        timeZoneId: '',
        accountNumber: '',
        sortCode: '',
      );

  factory TempUser.prefilled({
    required String email,
    required String country,
    String password = defaultPassword,
    String iban = Util.defaultIban,
    String phoneNumber = Util.defaultPhoneNumber,
    String firstName = Util.defaultFirstName,
    String lastName = Util.defaultLastName,
    String address = Util.defaultAdress,
    String city = Util.defaultCity,
    String postalCode = Util.defaultPostCode,
    String appLanguage = Util.defaulAppLanguage,
    String timeZoneId = Util.defaultTimeZoneId,
    String accountNumber = '',
    String sortCode = '',
    int amountLimit = 499,
  }) =>
      TempUser(
        email: email,
        iban: iban,
        phoneNumber: phoneNumber,
        firstName: firstName,
        lastName: lastName,
        address: address,
        city: city,
        postalCode: postalCode,
        country: country,
        password: password,
        appLanguage: appLanguage,
        amountLimit: amountLimit,
        timeZoneId: timeZoneId,
        accountNumber: accountNumber,
        sortCode: sortCode,
      );

  factory TempUser.fromJson(Map<String, dynamic> json) => TempUser(
        guid: json['GUID'] as String?,
        email: json['Email'] as String,
        iban: json.containsKey('IBAN') ? json['IBAN'] as String : '',
        phoneNumber: json['PhoneNumber'] as String,
        firstName: json['FirstName'] as String,
        lastName: json['LastName'] as String,
        address: json['Address'] as String,
        city: json['City'] as String,
        postalCode: json['PostalCode'] as String,
        country: json['Country'] as String,
        password: json['Password'] as String,
        amountLimit: json['AmountLimit'] as int,
        appLanguage:
            json['AppLanguage'] != null ? json['AppLanguage'] as String : '',
        timeZoneId: json['TimeZoneId'] as String,
        accountNumber: json.containsKey('AccountNumber')
            ? json['AccountNumber'] as String
            : '',
        sortCode:
            json.containsKey('SortCode') ? json['SortCode'] as String : '',
      );

  final String? guid;
  final String email;
  final String iban;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final String password;
  final int amountLimit;
  final String appLanguage;
  final String timeZoneId;
  final String accountNumber;
  final String sortCode;

  TempUser copyWith({
    String? guid,
    String? email,
    String? iban,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? address,
    String? city,
    String? postalCode,
    String? country,
    String? password,
    int? amountLimit,
    String? appLanguage,
    String? timeZoneId,
    String? accountNumber,
    String? sortCode,
  }) =>
      TempUser(
        guid: guid ?? this.guid,
        email: email ?? this.email,
        accountNumber: accountNumber ?? this.accountNumber,
        sortCode: sortCode ?? this.sortCode,
        iban: iban ?? this.iban,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        address: address ?? this.address,
        city: city ?? this.city,
        postalCode: postalCode ?? this.postalCode,
        country: country ?? this.country,
        password: password ?? this.password,
        amountLimit: amountLimit ?? this.amountLimit,
        appLanguage: appLanguage ?? this.appLanguage,
        timeZoneId: timeZoneId ?? this.timeZoneId,
      );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'Email': email,
      'PhoneNumber': phoneNumber,
      'FirstName': firstName,
      'LastName': lastName,
      'Address': address,
      'City': city,
      'PostalCode': postalCode,
      'Country': country,
      'Password': password,
      'AmountLimit': amountLimit,
      'AppLanguage': appLanguage,
      'TimeZoneId': timeZoneId,
    };
    if (guid != null) {
      json['GUID'] = guid;
    }
    if (iban.isNotEmpty) {
      json['IBAN'] = iban;
    }
    if (accountNumber.isNotEmpty && sortCode.isNotEmpty) {
      json['AccountNumber'] = accountNumber;
      json['SortCode'] = sortCode;
    }
    return json;
  }

  @override
  List<Object?> get props => [
        guid,
        email,
        iban,
        phoneNumber,
        firstName,
        lastName,
        address,
        city,
        postalCode,
        country,
        password,
        amountLimit,
        appLanguage,
        sortCode,
        accountNumber,
        timeZoneId,
      ];

  static const String defaultPassword = r'R4nd0mP@s$w0rd123';
}
