part of 'give_bloc.dart';

abstract class GiveEvent extends Equatable {
  const GiveEvent();

  @override
  List<Object?> get props => [];
}

class GiveQRCodeScanned extends GiveEvent {
  const GiveQRCodeScanned(this.encodedMediumId, this.userGUID);

  final String encodedMediumId;
  final String userGUID;

  @override
  List<Object> get props => [encodedMediumId, userGUID];
}

class GiveBTBeaconScanned extends GiveEvent {
  const GiveBTBeaconScanned({
    required this.macAddress,
    required this.rssi,
    required this.serviceUUID,
    required this.serviceData,
    required this.userGUID,
    required this.beaconData,
    this.threshold = true,
  });

  final String macAddress;
  final int rssi;
  final Guid serviceUUID;
  final Map<Guid, List<int>> serviceData;
  final String userGUID;
  final bool threshold;
  final String beaconData;

  @override
  List<Object> get props => [
        macAddress,
        threshold,
        rssi,
        userGUID,
        serviceUUID,
        serviceData,
        beaconData,
      ];
}

class GiveOrganisationSelected extends GiveEvent {
  const GiveOrganisationSelected({
    required this.nameSpace,
    required this.userGUID,
    this.goalId,
  });

  final String nameSpace;
  final String userGUID;
  final String? goalId;

  @override
  List<Object?> get props => [nameSpace, userGUID, goalId];
}

class GiveCheckLastDonation extends GiveEvent {
  const GiveCheckLastDonation();

  @override
  List<Object> get props => [];
}

class GiveToLastOrganisation extends GiveEvent {
  const GiveToLastOrganisation(this.userGUID);

  final String userGUID;

  @override
  List<Object> get props => [userGUID];
}

class GiveAmountChanged extends GiveEvent {
  const GiveAmountChanged({
    required this.firstCollectionAmount,
    required this.secondCollectionAmount,
    required this.thirdCollectionAmount,
  });

  final double firstCollectionAmount;
  final double secondCollectionAmount;
  final double thirdCollectionAmount;

  @override
  List<Object> get props => [
        firstCollectionAmount,
        secondCollectionAmount,
        thirdCollectionAmount,
      ];
}

class GiveQRCodeScannedOutOfApp extends GiveEvent {
  const GiveQRCodeScannedOutOfApp(
    this.encodedMediumId,
    this.afterGivingRedirection,
    this.userGUID, {
    this.amount = '',
  });

  final String encodedMediumId;
  final String afterGivingRedirection;
  final String userGUID;
  final String amount;

  @override
  List<Object> get props => [encodedMediumId, afterGivingRedirection, userGUID, amount];
}

class GiveConfirmQRCodeScannedOutOfApp extends GiveEvent {
  const GiveConfirmQRCodeScannedOutOfApp();

  @override
  List<Object> get props => [];
}

class GiveGPSLocationChanged extends GiveEvent {
  const GiveGPSLocationChanged({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  List<Object> get props => [latitude, longitude];
}

class GiveGPSConfirm extends GiveEvent {
  const GiveGPSConfirm(this.userGUID);

  final String userGUID;

  @override
  List<Object> get props => [userGUID];
}

class GiveStripeRegistrationError extends GiveEvent {
  const GiveStripeRegistrationError();

  @override
  List<Object> get props => [];
}

class GiveReset extends GiveEvent {
  const GiveReset();

  @override
  List<Object> get props => [];
}
