part of 'give_bloc.dart';

enum GiveStatus { initial, loading, success, error }

class GiveState extends Equatable {
  const GiveState({
    this.status = GiveStatus.initial,
    this.organisation = const Organisation(),
    this.collections = const [0.0, 0.0, 0.0],
    this.givt = '',
  });

  final GiveStatus status;
  final Organisation organisation;
  final List<double> collections;
  final String givt;

  GiveState copyWith({
    GiveStatus? status,
    Organisation? organisation,
    String? error,
    double? firstCollection,
    double? secondCollection,
    double? thirdCollection,
    String? givt,
  }) {
    return GiveState(
      status: status ?? this.status,
      organisation: organisation ?? this.organisation,
      collections: [
        firstCollection ?? collections[0],
        secondCollection ?? collections[1],
        thirdCollection ?? collections[2],
      ],
      givt: givt ?? this.givt,
    );
  }

  @override
  List<Object> get props => [
        status,
        organisation,
        collections,
        givt,
      ];
}
