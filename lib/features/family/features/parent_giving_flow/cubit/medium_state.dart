part of 'medium_cubit.dart';

class MediumState extends Equatable {
  const MediumState({
    this.mediumId = '',
  });
  final String mediumId;
  @override
  List<Object> get props => [mediumId];

  MediumState copyWith({
    String? mediumId,
  }) {
    return MediumState(
      mediumId: mediumId ?? this.mediumId,
    );
  }
}
