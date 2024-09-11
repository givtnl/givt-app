part of 'collectgroup_details_cubit.dart';

abstract class CollectGroupDetailsState extends Equatable {
  const CollectGroupDetailsState({
    required this.collectgroup,
    this.mediumId = '',
  });
  final CollectGroupDetails collectgroup;
  final String mediumId;

  @override
  List<Object> get props => [collectgroup, mediumId];
}

class OrganisationDetailsInitialState extends CollectGroupDetailsState {
  const OrganisationDetailsInitialState({
    super.collectgroup = const CollectGroupDetails.empty(),
  });
}

class OrganisationDetailsLoadingState extends CollectGroupDetailsState {
  const OrganisationDetailsLoadingState({
    super.collectgroup = const CollectGroupDetails.empty(),
  });
}

class OrganisationDetailsErrorState extends CollectGroupDetailsState {
  const OrganisationDetailsErrorState({
    super.collectgroup = const CollectGroupDetails.error(),
    super.mediumId,
  });
}

class OrganisationDetailsSetState extends CollectGroupDetailsState {
  const OrganisationDetailsSetState({
    required super.collectgroup,
    required super.mediumId,
  });
}
