part of 'gift_aid_registration_cubit.dart';

sealed class GiftAidRegistrationCustom {
  const GiftAidRegistrationCustom();

  const factory GiftAidRegistrationCustom.activated() =
      GiftAidRegistrationActivated;

  const factory GiftAidRegistrationCustom.skipped() = GiftAidRegistrationSkipped;
}

class GiftAidRegistrationActivated implements GiftAidRegistrationCustom {
  const GiftAidRegistrationActivated();
}

class GiftAidRegistrationSkipped implements GiftAidRegistrationCustom {
  const GiftAidRegistrationSkipped();
}

