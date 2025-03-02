part of 'give_cubit.dart';

sealed class GiveState extends Equatable {
  const GiveState();

  @override
  List<Object?> get props => [];
}

final class GiveInitial extends GiveState {}

final class GiveLoading extends GiveState {}

final class GiveFromBrowser extends GiveState {
  const GiveFromBrowser(
    this.givtTransactionObject,
    this.transaction,
    this.orgName,
    this.mediumId,
    this.experiencePoints,
  );

// this is legacy for the browser page
  final GivtTransaction givtTransactionObject;
  // this is the object we use for parent giving in US
  final Transaction transaction;
  final String orgName;
  final String mediumId;
  final int? experiencePoints;

  @override
  List<Object?> get props =>
      [givtTransactionObject, transaction, orgName, mediumId, experiencePoints];
}

final class GiveError extends GiveState {
  const GiveError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
