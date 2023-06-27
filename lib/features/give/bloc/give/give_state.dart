part of 'give_bloc.dart';

enum GiveStatus {
  initial,
  loading,
  readyToConfirm,
  readyToGive,
  processingBeaconData,
  noInternetConnection,
  success,
  error,
}

class GiveState extends Equatable {
  const GiveState({
    this.status = GiveStatus.initial,
    this.organisation  = const Organisation(),
    this.nearestBeacon = const Beacon.empty(),
    this.collections = const [0.0, 0.0, 0.0],
    this.givtTransactions = const [],
  });

  final GiveStatus status;
  final Organisation organisation;
  final Beacon nearestBeacon;
  final List<double> collections;
  final List<GivtTransaction> givtTransactions;

  GiveState copyWith({
    GiveStatus? status,
    Organisation? organisation,
    Beacon? nearestBeacon,
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
        collections,
        givtTransactions,
      ];
}
