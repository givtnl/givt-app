part of 'organisation_bloc.dart';

abstract class OrganisationState extends Equatable {
  const OrganisationState();


  @override
  List<Object> get props => [];
}

class OrganisationInitial extends OrganisationState {}

class OrganisationLoading extends OrganisationState {}

class OrganisationListFiltered extends OrganisationState {
  const OrganisationListFiltered(this.organisations);
  final List<Organisation> organisations;

  @override
  List<Object> get props => [organisations];
}
