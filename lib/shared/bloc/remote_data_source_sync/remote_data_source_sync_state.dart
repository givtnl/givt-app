part of 'remote_data_source_sync_bloc.dart';

abstract class RemoteDataSourceSyncState extends Equatable {
  const RemoteDataSourceSyncState();

  @override
  List<Object> get props => [];
}

class RemoteDataSourceSyncInitial extends RemoteDataSourceSyncState {}

class RemoteDataSourceSyncInProgress extends RemoteDataSourceSyncState {}

class RemoteDataSourceSyncSuccess extends RemoteDataSourceSyncState {}
