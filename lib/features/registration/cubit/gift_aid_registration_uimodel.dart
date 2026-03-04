part of 'gift_aid_registration_cubit.dart';

class GiftAidRegistrationUIModel {
  const GiftAidRegistrationUIModel({
    required this.user,
    required this.isCheckboxChecked,
  });

  final UserExt user;
  final bool isCheckboxChecked;

  GiftAidRegistrationUIModel copyWith({
    UserExt? user,
    bool? isCheckboxChecked,
  }) {
    return GiftAidRegistrationUIModel(
      user: user ?? this.user,
      isCheckboxChecked: isCheckboxChecked ?? this.isCheckboxChecked,
    );
  }
}

