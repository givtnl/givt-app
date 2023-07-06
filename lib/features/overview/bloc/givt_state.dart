part of 'givt_bloc.dart';

abstract class GivtState extends Equatable {
  const GivtState({
    this.givts = const [],
    this.givtGroups = const [],
  });

  final List<Givt> givts;
  final List<GivtGroup> givtGroups;

  @override
  List<Object> get props => [
        givts,
        givtGroups,
      ];
}

class GivtInitial extends GivtState {
  const GivtInitial() : super();
}

class GivtLoading extends GivtState {
  const GivtLoading() : super();
}

class GivtLoaded extends GivtState {
  const GivtLoaded({super.givts, super.givtGroups});
}
