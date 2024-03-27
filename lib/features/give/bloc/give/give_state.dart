part of 'give_bloc.dart';

enum GiveStatus {
  initial,
  loading,
  readyToConfirm,
  readyToConfirmGPS,
  readyToGive,
  processingBeaconData,
  noInternetConnection,
  donatedToSameOrganisationInLessThan30Seconds,
  beaconNotActive,
  success,
  processed,
  error,
}

class GiveState extends Equatable {
  const GiveState({
    this.status = GiveStatus.initial,
    this.organisation = const Organisation.empty(),
    this.nearestBeacon = const Beacon.empty(),
    this.nearestLocation = const Location.empty(),
    this.collections = const [0.0, 0.0, 0.0],
    this.givtTransactions = const [],
    this.instanceName = '',
    this.afterGivingRedirection = '',
  });

  final GiveStatus status;
  final Organisation organisation;
  final Beacon nearestBeacon;
  final Location nearestLocation;
  final List<double> collections;
  final List<GivtTransaction> givtTransactions;
  final String instanceName;
  final String afterGivingRedirection;

  GiveState copyWith({
    GiveStatus? status,
    Organisation? organisation,
    Beacon? nearestBeacon,
    Location? nearestLocation,
    String? error,
    double? firstCollection,
    double? secondCollection,
    double? thirdCollection,
    String? instanceName,
    String? afterGivingRedirection,
    List<GivtTransaction>? givtTransactions,
  }) {
    return GiveState(
      status: status ?? this.status,
      organisation: organisation ?? this.organisation,
      nearestBeacon: nearestBeacon ?? this.nearestBeacon,
      nearestLocation: nearestLocation ?? this.nearestLocation,
      instanceName: instanceName ?? this.instanceName,
      afterGivingRedirection:
          afterGivingRedirection ?? this.afterGivingRedirection,
      collections: [
        firstCollection ?? collections[0],
        secondCollection ?? collections[1],
        thirdCollection ?? collections[2],
      ],
      givtTransactions: givtTransactions ?? this.givtTransactions,
    );
  }

  @override
  List<Object> get props => [
        status,
        organisation,
        nearestBeacon,
        nearestLocation,
        collections,
        givtTransactions,
        instanceName,
        afterGivingRedirection,
      ];
}
