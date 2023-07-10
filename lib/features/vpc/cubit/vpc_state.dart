part of 'vpc_cubit.dart';

abstract class VPCState extends Equatable {
  const VPCState();

  @override
  List<Object> get props => [];
}

class VPCProfilesOverview extends VPCState {}

class VPCInfoState extends VPCState {}

class VPCFetchingURLState extends VPCState {}

class VPCErrorState extends VPCState {
  const VPCErrorState({required this.error});
  final String error;

  @override
  List<Object> get props => [error];
}

class VPCWebViewState extends VPCState {
  const VPCWebViewState({required this.response});
  final VPCResponse response;

  @override
  List<Object> get props => [response];
}

class VPCSuccessState extends VPCWebViewState {
  const VPCSuccessState({required super.response});
}

class VPCCanceledState extends VPCWebViewState {
  const VPCCanceledState({required super.response});
}
