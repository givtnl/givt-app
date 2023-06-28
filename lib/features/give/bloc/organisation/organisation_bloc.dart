import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/network/country_iso_info.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';

part 'organisation_event.dart';
part 'organisation_state.dart';

class OrganisationBloc extends Bloc<OrganisationEvent, OrganisationState> {
  OrganisationBloc(
    this._collectGroupRepository,
    this._campaignRepository,
    this._countryIsoInfo,
  ) : super(const OrganisationState()) {
    on<OrganisationFetch>(_onOrganisationFetch);

    on<OrganisationFilterQueryChanged>(_onFilterQueryChanged);

    on<OrganisationTypeChanged>(_onTypeChanged);

    on<OrganisationSelectionChanged>(_onSelectionChanged);
  }

  final CollectGroupRepository _collectGroupRepository;
  final CampaignRepository _campaignRepository;
  final CountryIsoInfo _countryIsoInfo;

  FutureOr<void> _onOrganisationFetch(
    OrganisationFetch event,
    Emitter<OrganisationState> emit,
  ) async {
    emit(state.copyWith(status: OrganisationStatus.loading));
    try {
      final lastDonatedOrganisation =
          await _campaignRepository.getLastOrganisationDonated();
      final unFiltered = await _collectGroupRepository.getCollectGroupList();
      final userAccountType = await _getAccountType(event.accountType);
      final organisations = unFiltered
          .where(
            (organisation) => organisation.accountType == userAccountType,
          )
          .toList();
      var selectedGroup = state.selectedCollectGroup;
      if (lastDonatedOrganisation.mediumId!.isNotEmpty) {
        selectedGroup = organisations.firstWhere(
          (organisation) => lastDonatedOrganisation.mediumId!.contains(
            organisation.nameSpace,
          ),
        );
        organisations
          ..removeWhere(
            (organisation) =>
                organisation.nameSpace == lastDonatedOrganisation.mediumId,
          )
          ..insert(
            0,
            selectedGroup,
          );
      }
      emit(
        state.copyWith(
          status: OrganisationStatus.filtered,
          organisations: organisations,
          filteredOrganisations: organisations,
          selectedCollectGroup: selectedGroup,
        ),
      );
    } catch (e) {
      log(e.toString());
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
    final selectedNow = state.organisations.firstWhere(
      (organisation) => organisation.nameSpace == event.mediumId,
    );
    emit(
      state.copyWith(
        status: OrganisationStatus.filtered,
        selectedCollectGroup: state.selectedCollectGroup == selectedNow
            ? const CollectGroup.empty()
            : selectedNow,
      ),
    );
  }

  Future<AccountType> _getAccountType(AccountType accountType) async {
    if (accountType != AccountType.none) {
      return accountType;
    }
    final countryIso = await _countryIsoInfo.checkCountryIso;

    final country = Country.values.firstWhere(
      (country) => country.countryCode == countryIso,
      orElse: () => Country.unknown,
    );

    if (country.isBACS) {
      return AccountType.bacs;
    }
    if (country.isCreditCard) {
      return AccountType.creditCard;
    }
    return AccountType.sepa;
  }
}
