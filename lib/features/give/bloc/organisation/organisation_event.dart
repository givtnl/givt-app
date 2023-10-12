part of 'organisation_bloc.dart';

abstract class OrganisationEvent extends Equatable {
  const OrganisationEvent();

  @override
  List<Object> get props => [];
}

class OrganisationFetch extends OrganisationEvent {
  const OrganisationFetch(
    this.country, {
    required this.type,
    this.showLastDonated = true,
  });

  final Country country;
  final int type;
  final bool showLastDonated;

  @override
  List<Object> get props => [country, type, showLastDonated];
}

class OrganisationFetchForSelection extends OrganisationEvent {
  const OrganisationFetchForSelection(this.country);

  final Country country;

  @override
  List<Object> get props => [country];
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
