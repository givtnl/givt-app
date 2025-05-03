import 'package:equatable/equatable.dart';
import 'package:givt_app/shared/models/collect_group.dart';

class SelectOrganisationUIModel extends Equatable {
  const SelectOrganisationUIModel({
    this.organizations = const [],
    this.selectedOrganization,
    this.isLoading = false,
    this.error,
  });

  final List<CollectGroup> organizations;
  final CollectGroup? selectedOrganization;
  final bool isLoading;
  final String? error;

  SelectOrganisationUIModel copyWith({
    List<CollectGroup>? organizations,
    CollectGroup? selectedOrganization,
    bool? isLoading,
    String? error,
  }) {
    return SelectOrganisationUIModel(
      organizations: organizations ?? this.organizations,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [organizations, selectedOrganization, isLoading, error];
} 