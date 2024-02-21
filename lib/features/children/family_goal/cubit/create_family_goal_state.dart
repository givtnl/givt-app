part of 'create_family_goal_cubit.dart';

enum FamilyGoalCreationStatus {
  overview,
  cause,
  amount,
  confirmation,
  loading,
  confirmed,
  ;

  FamilyGoalCreationStatus get previous {
    return index > overview.index && index <= confirmation.index
        ? FamilyGoalCreationStatus.values[index - 1]
        : overview;
  }
}

class CreateFamilyGoalState extends Equatable {
  const CreateFamilyGoalState({
    this.status = FamilyGoalCreationStatus.overview,
    this.error = '',
    this.mediumId = '',
    this.amount = 0,
    this.organisationName = '',
    this.collectGroupList = const [],
  });

  final FamilyGoalCreationStatus status;
  final String error;
  final String mediumId;
  final num amount;
  final String organisationName;
  final List<CollectGroup> collectGroupList;

  @override
  List<Object> get props =>
      [status, error, mediumId, amount, organisationName, collectGroupList];

  CreateFamilyGoalState copyWith({
    FamilyGoalCreationStatus? status,
    String? error,
    String? mediumId,
    num? amount,
    String? organisationName,
    List<CollectGroup>? collectGroupList,
  }) {
    return CreateFamilyGoalState(
      status: status ?? this.status,
      error: error ?? this.error,
      mediumId: mediumId ?? this.mediumId,
      amount: amount ?? this.amount,
      organisationName: organisationName ?? this.organisationName,
      collectGroupList: collectGroupList ?? this.collectGroupList,
    );
  }
}
