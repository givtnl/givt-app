part of 'givt_bloc.dart';

abstract class GivtState extends Equatable {
  const GivtState({this.givts = const []});

  final List<Givt> givts;

  @override
  List<Object> get props => [];
}

class GivtInitial extends GivtState {
  const GivtInitial() : super();
}

class GivtLoading extends GivtState {
  const GivtLoading() : super();
}

class GivtLoaded extends GivtState {
  const GivtLoaded(List<Givt> givts) : super(givts: givts);
}
