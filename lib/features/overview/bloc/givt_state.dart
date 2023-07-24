part of 'givt_bloc.dart';

abstract class GivtState extends Equatable {
  const GivtState({
    this.givts = const [],
    this.givtGroups = const [],
    this.givtAided = const {},
  });

  final List<Givt> givts;
  final List<GivtGroup> givtGroups;
  final Map<int, double> givtAided;

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

class GivtDownloadedSuccess extends GivtState {
  const GivtDownloadedSuccess() : super();
}

class GivtNoInternet extends GivtState {
  const GivtNoInternet() : super();
}

class GivtError extends GivtState {
  const GivtError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

class GivtLoaded extends GivtState {
  const GivtLoaded({
    super.givts,
    super.givtGroups,
    super.givtAided,
  });
}
