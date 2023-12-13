part of 'organisation_bloc.dart';

enum OrganisationStatus {
  initial,
  loading,
  error,
  filtered,
}

class OrganisationState extends Equatable {
  const OrganisationState({
    this.organisations = const [],
    this.filteredOrganisations = const [],
    this.selectedType = -1,
    this.selectedCollectGroup = const CollectGroup.empty(),
    this.status = OrganisationStatus.initial,
    this.previousSearchQuery = '',
  });

  final List<CollectGroup> organisations;
  final List<CollectGroup> filteredOrganisations;
  final int selectedType;
  final String previousSearchQuery;
  final CollectGroup selectedCollectGroup;
  final OrganisationStatus status;

  OrganisationState copyWith({
    List<CollectGroup>? organisations,
    List<CollectGroup>? filteredOrganisations,
    int? selectedType,
    OrganisationStatus? status,
    CollectGroup? selectedCollectGroup,
    String? previousSearchQuery,
  }) {
    return OrganisationState(
      organisations: organisations ?? this.organisations,
      filteredOrganisations:
          filteredOrganisations ?? this.filteredOrganisations,
      selectedType: selectedType ?? this.selectedType,
      status: status ?? this.status,
      selectedCollectGroup: selectedCollectGroup ?? this.selectedCollectGroup,
      previousSearchQuery: previousSearchQuery ?? this.previousSearchQuery,
    );
  }

  @override
  List<Object> get props => [
        organisations,
        selectedType,
        filteredOrganisations,
        status,
        selectedCollectGroup,
        previousSearchQuery,
      ];
}
