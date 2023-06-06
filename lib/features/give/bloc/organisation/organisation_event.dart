part of 'organisation_bloc.dart';

abstract class OrganisationEvent extends Equatable {
  const OrganisationEvent();

  @override
  List<Object> get props => [];
}

class OrganisationStarted extends OrganisationEvent {
  const OrganisationStarted();
}

class OrganisationTypeChanged extends OrganisationEvent {
  const OrganisationTypeChanged(this.type);

  final int type;

  @override
  List<Object> get props => [type];
}

class OrganisationFilterQueryChanged extends OrganisationEvent {
  const OrganisationFilterQueryChanged(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}

class OrganisationSelected extends OrganisationEvent {
  const OrganisationSelected(this.organisation);

  final 

  @override
  List<Object> get props => [organisation];
}
