part of 'organisation_bloc.dart';

abstract class OrganisationEvent extends Equatable {
  const OrganisationEvent();

  @override
  List<Object> get props => [];
}

class OrganisationFetch extends OrganisationEvent {
  const OrganisationFetch(
    this.accountType, {
    this.showLastDonated = true,
    required this.type,
  });

  final AccountType accountType;
  final int type;
  final bool showLastDonated;

  @override
  List<Object> get props => [accountType, type, showLastDonated];
}

class OrganisationFetchForSelection extends OrganisationEvent {
  const OrganisationFetchForSelection(this.accountType);

  final AccountType accountType;

  @override
  List<Object> get props => [accountType];
}

class OrganisationTypeChanged extends OrganisationEvent {
  const OrganisationTypeChanged(this.type);

  final int type;

  @override
  List<Object> get props => [type];
}

class OrganisationSelectionChanged extends OrganisationEvent {
  const OrganisationSelectionChanged(this.mediumId);

  final String mediumId;

  @override
  List<Object> get props => [mediumId];
}

class OrganisationFilterQueryChanged extends OrganisationEvent {
  const OrganisationFilterQueryChanged(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}
