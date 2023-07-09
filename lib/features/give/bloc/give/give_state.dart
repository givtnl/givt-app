part of 'give_bloc.dart';

enum GiveStatus {
  initial,
  loading,
  readyToConfirm,
  readyToConfirmGPS,
  readyToGive,
  processingBeaconData,
  noInternetConnection,
  success,
  error,
}

class GiveState extends Equatable {
  const GiveState({
    this.status = GiveStatus.initial,
    this.organisation  = const Organisation.empty(),
    this.nearestBeacon = const Beacon.empty(),
    this.nearestLocation = const Location.empty(),
    this.collections = const [0.0, 0.0, 0.0],
    this.givtTransactions = const [],
  });

  final GiveStatus status;
  final Organisation organisation;
  final Beacon nearestBeacon;
  final Location nearestLocation;
  final List<double> collections;
  final List<GivtTransaction> givtTransactions;

  GiveState copyWith({
    GiveStatus? status,
    Organisation? organisation,
    Beacon? nearestBeacon,
    Location? nearestLocation,
    String? error,
    double? firstCollection,
    double? secondCollection,
    double? thirdCollection,
    List<GivtTransaction>? givtTransactions,
  }) {
    return GiveState(
      status: status ?? this.status,
      organisation: organisation ?? this.organisation,
      nearestBeacon: nearestBeacon ?? this.nearestBeacon,
      nearestLocation: nearestLocation ?? this.nearestLocation,
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
      ];
}
