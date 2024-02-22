part of 'create_family_goal_cubit.dart';

enum FamilyGoalCreationStatus {
  overview,
  cause,
  amount,
  confirmation,
  loading,
  confirmed,
  ;
}

class CreateFamilyGoalState extends Equatable {
  const CreateFamilyGoalState({
    this.status = FamilyGoalCreationStatus.overview,
    this.error = '',
    this.mediumId = '',
    this.amount = 0,
    this.organisationName = '',
  });

  final FamilyGoalCreationStatus status;
  final String error;
  final String mediumId;
  final num amount;
  final String organisationName;

  @override
  List<Object> get props => [status, error, mediumId, amount, organisationName];

  CreateFamilyGoalState copyWith({
    FamilyGoalCreationStatus? status,
    String? error,
    String? mediumId,
    num? amount,
    String? organisationName,
  }) {
    return CreateFamilyGoalState(
      status: status ?? this.status,
      error: error ?? '', //clear existing error for the new state
      mediumId: mediumId ?? this.mediumId,
      amount: amount ?? this.amount,
      organisationName: organisationName ?? this.organisationName,
    );
  }
}
