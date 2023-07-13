part of 'givt_bloc.dart';

abstract class GivtEvent extends Equatable {
  const GivtEvent();

  @override
  List<Object> get props => [];
}

class GivtInit extends GivtEvent {
  const GivtInit();

  @override
  List<Object> get props => [];
}

class GiveDelete extends GivtEvent {
  const GiveDelete({
    required this.timestamp,
  });

  final DateTime timestamp;

  @override
  List<Object> get props => [timestamp];
}
