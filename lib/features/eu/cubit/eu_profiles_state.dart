part of 'eu_profiles_cubit.dart';

abstract class EuProfilesState extends Equatable {
  const EuProfilesState();

  @override
  List<Object?> get props => [];
}

class EuProfilesInitialState extends EuProfilesState {
  const EuProfilesInitialState();
}

class EuProfilesLoadingState extends EuProfilesState {
  const EuProfilesLoadingState();
}

class EuProfilesUpdatedState extends EuProfilesState {
  const EuProfilesUpdatedState({required this.profiles});

  final List<EuProfile> profiles;

  @override
  List<Object?> get props => [profiles];
}

class EuProfilesErrorState extends EuProfilesState {
  const EuProfilesErrorState({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}