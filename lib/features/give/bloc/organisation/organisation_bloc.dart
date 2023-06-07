import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';

part 'organisation_event.dart';
part 'organisation_state.dart';

class OrganisationBloc extends Bloc<OrganisationEvent, OrganisationState> {
  OrganisationBloc(this._collectGroupRepository)
      : super(const OrganisationState()) {
    on<OrganisationFetch>(_onOrganisationFetch);

    on<OrganisationFilterQueryChanged>(_onFilterQueryChanged);

    on<OrganisationTypeChanged>(_onTypeChanged);

    on<OrganisationSelectionChanged>(_onSelectionChanged);
  }

  final CollectGroupRepository _collectGroupRepository;

  FutureOr<void> _onOrganisationFetch(
    OrganisationFetch event,
    Emitter<OrganisationState> emit,
  ) async {
    emit(state.copyWith(status: OrganisationStatus.loading));
    try {
      final organisations = await _collectGroupRepository.getCollectGroupList();
      emit(
        state.copyWith(
          status: OrganisationStatus.filtered,
          organisations: organisations,
          filteredOrganisations: organisations,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: OrganisationStatus.error));
    }
  }

  FutureOr<void> _onFilterQueryChanged(
    OrganisationFilterQueryChanged event,
    Emitter<OrganisationState> emit,
  ) async {
    emit(state.copyWith(status: OrganisationStatus.loading));
    try {
      final filteredOrganisations = state.organisations
          .where(
            (organisation) => organisation.orgName.toLowerCase().contains(
                  event.query.toLowerCase(),
                ),
          )
          .toList();

      if (filteredOrganisations.isEmpty) {
        emit(
          state.copyWith(
            status: OrganisationStatus.filtered,
            filteredOrganisations: state.organisations,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          status: OrganisationStatus.filtered,
          filteredOrganisations: filteredOrganisations,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: OrganisationStatus.error));
    }
  }

  FutureOr<void> _onTypeChanged(
    OrganisationTypeChanged event,
    Emitter<OrganisationState> emit,
  ) {
    emit(
      state.copyWith(
        selectedType: state.selectedType == event.type ? -1 : event.type,
        filteredOrganisations: state.selectedType == event.type
            ? state.organisations
            : state.organisations
                .where((organisation) => organisation.type.value == event.type)
                .toList(),
      ),
    );
  }

  FutureOr<void> _onSelectionChanged(
    OrganisationSelectionChanged event,
    Emitter<OrganisationState> emit,
  ) {
    emit(
      state.copyWith(status: OrganisationStatus.loading),
    );
    emit(
      state.copyWith(
        status: OrganisationStatus.filtered,
        selectedCollectGroup:
            state.selectedCollectGroup == state.organisations[event.index]
                ? const CollectGroup.empty()
                : state.organisations[event.index],
      ),
    );
  }
}
