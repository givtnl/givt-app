import 'package:equatable/equatable.dart';

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
  });

  factory UserExt.empty() => const UserExt(
        email: '',
        guid: '',
        amountLimit: 0,
      );

  factory UserExt.fromJson(Map<String, dynamic> json) => UserExt(
        email: json['Email'] as String,
        guid: json['GUID'] as String,
        amountLimit: 400,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'Email': email,
        'GUID': guid,
        'amountLimit': amountLimit,
        'tempUser': tempUser,
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
