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

class GivtDownloadOverviewByYear extends GivtEvent {
  const GivtDownloadOverviewByYear({
    required this.year,
    required this.guid,
  });
  final String year;
  final String guid;

  @override
  List<Object> get props => [year, guid];
}

class GiveDelete extends GivtEvent {
  const GiveDelete({
    required this.timestamp,
  });

  final DateTime timestamp;

  @override
  List<Object> get props => [timestamp];
}
