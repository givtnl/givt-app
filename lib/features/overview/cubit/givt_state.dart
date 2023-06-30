part of 'givt_cubit.dart';

abstract class GivtState extends Equatable {
  const GivtState({this.givts = const []});

  final List<Givt> givts;

  @override
  List<Object> get props => [givts];
}

class GivtInitial extends GivtState {
  const GivtInitial();
}

class GivtLoading extends GivtState {
  const GivtLoading();
}

class GivtLoaded extends GivtState {
  const GivtLoaded(List<Givt> givts) : super(givts: givts);
}

class GivtError extends GivtState {
  const GivtError();
}
