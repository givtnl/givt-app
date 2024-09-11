part of 'collectgroup_details_cubit.dart';

abstract class OrganisationDetailsState extends Equatable {
  const OrganisationDetailsState({
    required this.collectgroup,
    this.mediumId = '',
  });
  final CollectGroupDetails collectgroup;
  final String mediumId;

  @override
  List<Object> get props => [collectgroup, mediumId];
}

class OrganisationDetailsInitialState extends OrganisationDetailsState {
  const OrganisationDetailsInitialState({
    super.collectgroup = const CollectGroupDetails.empty(),
  });
}

class OrganisationDetailsLoadingState extends OrganisationDetailsState {
  const OrganisationDetailsLoadingState({
    super.collectgroup = const CollectGroupDetails.empty(),
  });
}

class OrganisationDetailsErrorState extends OrganisationDetailsState {
  const OrganisationDetailsErrorState({
    super.collectgroup = const CollectGroupDetails.error(),
    super.mediumId,
  });
}

class OrganisationDetailsSetState extends OrganisationDetailsState {
  const OrganisationDetailsSetState({
    required super.collectgroup,
    required super.mediumId,
  });
}
