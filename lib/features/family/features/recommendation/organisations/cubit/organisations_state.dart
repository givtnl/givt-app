part of 'organisations_cubit.dart';

abstract class OrganisationsState extends Equatable {
  const OrganisationsState({required this.organisations});

  final List<Organisation> organisations;

  @override
  List<Object?> get props => [organisations];
}

class OrganisationsInitialState extends OrganisationsState {
  const OrganisationsInitialState() : super(organisations: const []);
}

class OrganisationsFetchingState extends OrganisationsState {
  const OrganisationsFetchingState() : super(organisations: const []);
}

class OrganisationsFetchedState extends OrganisationsState {
  const OrganisationsFetchedState({required super.organisations});
}

class OrganisationsExternalErrorState extends OrganisationsState {
  const OrganisationsExternalErrorState({required this.errorMessage})
      : super(organisations: const []);

  final String errorMessage;

  @override
  List<Object?> get props => [organisations, errorMessage];
}
