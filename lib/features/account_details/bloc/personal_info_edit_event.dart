part of 'personal_info_edit_bloc.dart';

abstract class PersonalInfoEditEvent extends Equatable {
  const PersonalInfoEditEvent();

  @override
  List<Object> get props => [];
}

class PersonalInfoEditEmail extends PersonalInfoEditEvent {
  const PersonalInfoEditEmail({
    required this.email,
  });

  final String email;

  @override
  List<Object> get props => [email];
}

class PersonalInfoEditBankDetails extends PersonalInfoEditEvent {
  const PersonalInfoEditBankDetails({
    required this.iban,
    required this.accountNumber,
    required this.sortCode,
  });

  final String iban;
  final String accountNumber;
  final String sortCode;

  @override
  List<Object> get props => [
        iban,
        accountNumber,
        sortCode,
      ];
}

class PersonalInfoEditPhoneNumber extends PersonalInfoEditEvent {
  const PersonalInfoEditPhoneNumber({
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

class PersonalInfoEditAddress extends PersonalInfoEditEvent {
  const PersonalInfoEditAddress({
    required this.address,
    required this.postalCode,
    required this.city,
    required this.country,
  });

  final String address;
  final String postalCode;
  final String city;
  final String country;

  @override
  List<Object> get props => [
        address,
        postalCode,
        city,
        country,
      ];
}

class PersonalInfoEditGiftAid extends PersonalInfoEditEvent {
  const PersonalInfoEditGiftAid({
    required this.isGiftAidEnabled,
  });

  final bool isGiftAidEnabled;

  @override
  List<Object> get props => [isGiftAidEnabled];
}
