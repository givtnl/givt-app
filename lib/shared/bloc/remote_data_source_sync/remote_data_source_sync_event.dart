part of 'remote_data_source_sync_bloc.dart';

abstract class RemoteDataSourceSyncEvent extends Equatable {
  const RemoteDataSourceSyncEvent();

  @override
  List<Object> get props => [];
}

class RemoteDataSourceSyncRequested extends RemoteDataSourceSyncEvent {
  const RemoteDataSourceSyncRequested();

  @override
  List<Object> get props => [];
}
