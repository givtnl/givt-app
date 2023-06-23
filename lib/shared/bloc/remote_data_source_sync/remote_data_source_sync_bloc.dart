import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

part 'remote_data_source_sync_event.dart';
part 'remote_data_source_sync_state.dart';

class RemoteDataSourceSyncBloc
    extends Bloc<RemoteDataSourceSyncEvent, RemoteDataSourceSyncState> {
  RemoteDataSourceSyncBloc(
    this._collectGroupRepository,
    this._givtRepository,
  ) : super(RemoteDataSourceSyncInitial()) {
    on<RemoteDataSourceSyncRequested>(_onSyncRequested);
  }

  final CollectGroupRepository _collectGroupRepository;
  final GivtRepository _givtRepository;

  FutureOr<void> _onSyncRequested(
    event,
    Emitter<RemoteDataSourceSyncState> emit,
  ) async {
    emit(RemoteDataSourceSyncInProgress());
    try {
      await _collectGroupRepository.fetchCollectGroupList();
      await _givtRepository.syncOfflineGivts();
      emit(RemoteDataSourceSyncSuccess());
    } catch (e) {
      log(e.toString());
      emit(RemoteDataSourceSyncInitial());
    }
  }
}
