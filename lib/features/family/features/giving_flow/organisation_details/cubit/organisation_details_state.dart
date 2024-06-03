part of 'organisation_details_cubit.dart';

abstract class OrganisationDetailsState extends Equatable {
  const OrganisationDetailsState({
    required this.organisation,
    this.mediumId = '',
  });
  final OrganisationDetails organisation;
  final String mediumId;

  @override
  List<Object> get props => [organisation, mediumId];
}

class OrganisationDetailsInitialState extends OrganisationDetailsState {
  const OrganisationDetailsInitialState({
    super.organisation = const OrganisationDetails.empty(),
  });
}

class OrganisationDetailsLoadingState extends OrganisationDetailsState {
  const OrganisationDetailsLoadingState({
    super.organisation = const OrganisationDetails.empty(),
  });
}

class OrganisationDetailsErrorState extends OrganisationDetailsState {
  const OrganisationDetailsErrorState({
    super.organisation = const OrganisationDetails.error(),
    super.mediumId,
  });
}

class OrganisationDetailsSetState extends OrganisationDetailsState {
  const OrganisationDetailsSetState({
    required super.organisation,
    required super.mediumId,
  });
}
