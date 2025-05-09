import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:diacritic/diacritic.dart';
import 'package:equatable/equatable.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/models/models.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'organisation_event.dart';
part 'organisation_state.dart';

// Minimum score threshold for fuzzy search results (0-100)
const int _fuzzyScoreThreshold = 70;

class OrganisationBloc extends Bloc<OrganisationEvent, OrganisationState> {
  OrganisationBloc(
    this._collectGroupRepository,
    this._campaignRepository,
    this._sharedPreferences,
  ) : super(const OrganisationState()) {
    on<OrganisationFetch>(_onOrganisationFetch);

    on<OrganisationFetchForSelection>(_onOrganisationFetchForSelection);

    on<OrganisationFilterQueryChanged>(_onFilterQueryChanged);

    on<OrganisationTypeChanged>(_onTypeChanged);

    on<OrganisationSelectionChanged>(_onSelectionChanged);

    on<AddOrganisationToFavorites>(_onAddOrganisationToFavorites);
    on<RemoveOrganisationFromFavorites>(_onRemoveOrganisationFromFavorites);
    on<FavoritesRefresh>(_onFavoritesRefresh);
  }

  final CollectGroupRepository _collectGroupRepository;
  final CampaignRepository _campaignRepository;
  final SharedPreferences _sharedPreferences;

  Organisation lastDonatedOrganisation = const Organisation.empty();

  String _getFavoritedOrganisationsKey(String userGuid) {
    return '${Util.favoritedOrganisationsKey}$userGuid';
  }

  String _getUserGuid() {
    final sessionString = _sharedPreferences.getString(Session.tag);
    if (sessionString == null) {
      return '';
    }
    final session = Session.fromJson(
      jsonDecode(sessionString) as Map<String, dynamic>,
    );
    return session.userGUID;
  }

  List<CollectGroup> _applySorting(
    List<CollectGroup> organisations,
  ) {
    // Always sort the selected group to the top
    organisations.sort((CollectGroup a, CollectGroup b) {
      if (a == state.selectedCollectGroup &&
          a.orgName == lastDonatedOrganisation.organisationName) return -1;
      if (b == state.selectedCollectGroup &&
          b.orgName == lastDonatedOrganisation.organisationName) return 1;

      // Then sort favorites to the top
      final aIsFavorited = state.favoritedOrganisations.contains(a.nameSpace);
      final bIsFavorited = state.favoritedOrganisations.contains(b.nameSpace);
      if (aIsFavorited && !bIsFavorited) return -1;
      if (!aIsFavorited && bIsFavorited) return 1;

      // Finally, sort alphabetically by organization name
      return a.orgName.compareTo(b.orgName);
    });
    return organisations;
  }

  FutureOr<void> _onFavoritesRefresh(
    OrganisationEvent event,
    Emitter<OrganisationState> emit,
  ) {
    final userGuid = _getUserGuid();
    final key = _getFavoritedOrganisationsKey(userGuid);
    final favoritedOrganisations = _sharedPreferences.getStringList(key) ?? [];
    emit(
      state.copyWith(favoritedOrganisations: favoritedOrganisations),
    );
    emit(
      state.copyWith(
        filteredOrganisations: _applySorting(
          state.filteredOrganisations,
        ),
      ),
    );
  }

  FutureOr<void> _onOrganisationFetch(
    OrganisationFetch event,
    Emitter<OrganisationState> emit,
  ) async {
    emit(state.copyWith(status: OrganisationStatus.loading));
    try {
      final userGuid = _getUserGuid();
      final key = _getFavoritedOrganisationsKey(userGuid);
      final favoritedOrganisations =
          _sharedPreferences.getStringList(key) ?? [];
      emit(
        state.copyWith(favoritedOrganisations: favoritedOrganisations),
      );

      var unFiltered = await _collectGroupRepository.getCollectGroupList();
      if (unFiltered.isEmpty) {
        unFiltered = await _collectGroupRepository.fetchCollectGroupList();
      }
      final userAccountType = await _getAccountType(event.country);
      final organisations = unFiltered
          .where(
            (organisation) => organisation.accountType == userAccountType,
          )
          .toList();
      var selectedGroup = state.selectedCollectGroup;
      if (event.showLastDonated) {
        lastDonatedOrganisation =
            await _campaignRepository.getLastOrganisationDonated();
        if (lastDonatedOrganisation.mediumId != null) {
          if (lastDonatedOrganisation.mediumId!.isNotEmpty) {
            selectedGroup = organisations.firstWhere(
              (organisation) => lastDonatedOrganisation.mediumId!.contains(
                organisation.nameSpace,
              ),
              orElse: () => const CollectGroup.empty(),
            );
            if (selectedGroup.nameSpace.isNotEmpty) {
              organisations
                ..removeWhere(
                  (organisation) =>
                      organisation.nameSpace ==
                      lastDonatedOrganisation.mediumId,
                )
                ..insert(
                  0,
                  selectedGroup,
                );
            }
          }
        }
      }
      emit(
        state.copyWith(
          selectedCollectGroup: selectedGroup,
        ),
      );
      emit(
        state.copyWith(
          status: OrganisationStatus.filtered,
          organisations: organisations,
          filteredOrganisations: _applySorting(organisations),
          selectedCollectGroup: selectedGroup,
          favoritedOrganisations: favoritedOrganisations,
        ),
      );
      if (event.type == CollectGroupType.none.index) {
        emit(
          state.copyWith(selectedType: event.type),
        );
      }
      if (event.type != CollectGroupType.none.index) {
        add(OrganisationTypeChanged(event.type));
      }
    } on GivtServerFailure catch (e, stackTrace) {
      final statusCode = e.statusCode;
      final body = e.body;
      log('StatusCode:$statusCode Body:$body');
      LoggingInfo.instance.error(
        body.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: OrganisationStatus.error));
    }
  }

  FutureOr<void> _onOrganisationFetchForSelection(
    OrganisationFetchForSelection event,
    Emitter<OrganisationState> emit,
  ) async {
    final userGuid = _getUserGuid();
    final key = _getFavoritedOrganisationsKey(userGuid);
    final favoritedOrganisations = _sharedPreferences.getStringList(key) ?? [];
    emit(
      state.copyWith(favoritedOrganisations: favoritedOrganisations),
    );

    emit(state.copyWith(status: OrganisationStatus.loading));
    try {
      final unFiltered = await _collectGroupRepository.getCollectGroupList();
      final userAccountType = await _getAccountType(event.country);
      final organisations = unFiltered
          .where(
            (organisation) => organisation.accountType == userAccountType,
          )
          .toList();
      emit(
        state.copyWith(
          status: OrganisationStatus.filtered,
          organisations: organisations,
          filteredOrganisations: _applySorting(organisations),
          favoritedOrganisations: favoritedOrganisations,
        ),
      );
    } on GivtServerFailure catch (e, stackTrace) {
      final statusCode = e.statusCode;
      final body = e.body;
      log('StatusCode:$statusCode Body:$body');
      LoggingInfo.instance.warning(
        body.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: OrganisationStatus.error));
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: OrganisationStatus.error));
    }
  }

  FutureOr<void> _onFilterQueryChanged(
    OrganisationFilterQueryChanged event,
    Emitter<OrganisationState> emit,
  ) async {
    emit(state.copyWith(status: OrganisationStatus.loading));
    try {
      final query = _removeDiacritics(event.query.toLowerCase());

      // Filter organizations by type first if there's a selected type
      final typeFilteredOrgs = state.organisations
          .where(
            (org) =>
                state.selectedType == CollectGroupType.none.index ||
                org.type.index == state.selectedType,
          )
          .toList();

      // If query is empty, just apply the type filter
      if (query.isEmpty) {
        emit(
          state.copyWith(
            status: OrganisationStatus.filtered,
            filteredOrganisations: _applySorting(typeFilteredOrgs),
            previousSearchQuery: event.query,
          ),
        );
        return;
      }

      // First try exact substring matching
      final exactMatches = typeFilteredOrgs
          .where(
            (org) =>
                _removeDiacritics(org.orgName.toLowerCase()).contains(query),
          )
          .toList();

      // If we have exact matches, use those
      if (exactMatches.isNotEmpty) {
        emit(
          state.copyWith(
            status: OrganisationStatus.filtered,
            filteredOrganisations: _applySorting(exactMatches),
            previousSearchQuery: event.query,
          ),
        );
        return;
      }

      // If no exact matches, use fuzzy matching
      final orgNames = typeFilteredOrgs
          .map(
            (org) => _removeDiacritics(org.orgName.toLowerCase()),
          )
          .toList();

      // Extract fuzzy matched results
      final fuzzyResults = extractAllSorted(
        query: query,
        choices: orgNames,
      ).where((result) => result.score >= _fuzzyScoreThreshold).toList();

      // Map fuzzy results back to organization objects
      final fuzzyMatches = fuzzyResults.map((result) {
        final index = orgNames.indexOf(result.choice);
        return typeFilteredOrgs[index];
      }).toList();

      emit(
        state.copyWith(
          status: OrganisationStatus.filtered,
          filteredOrganisations: _applySorting(fuzzyMatches),
          previousSearchQuery: event.query,
        ),
      );
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: OrganisationStatus.error));
    }
  }

  FutureOr<void> _onTypeChanged(
    OrganisationTypeChanged event,
    Emitter<OrganisationState> emit,
  ) async {
    final newSelectedType = state.selectedType == event.type
        ? CollectGroupType.none.index
        : event.type;

    _handleTypeChange(newSelectedType, emit);
  }

  void _handleTypeChange(int newSelectedType, Emitter<OrganisationState> emit) {
    // Get all organizations or just those of the selected type
    var orgs = state.organisations;
    if (newSelectedType != CollectGroupType.none.index) {
      orgs = state.organisations
          .where((org) => org.type.index == newSelectedType)
          .toList();
    }

    // If there's an active search query, apply both filters
    if (state.previousSearchQuery.isNotEmpty) {
      final query = _removeDiacritics(state.previousSearchQuery.toLowerCase());

      // First try exact matching
      var filteredOrgs = orgs
          .where(
            (org) =>
                _removeDiacritics(org.orgName.toLowerCase()).contains(query),
          )
          .toList();

      // If no exact matches, try fuzzy matching
      if (filteredOrgs.isEmpty) {
        final orgNames = orgs
            .map(
              (org) => _removeDiacritics(org.orgName.toLowerCase()),
            )
            .toList();

        final fuzzyResults = extractAllSorted(
          query: query,
          choices: orgNames,
        ).where((result) => result.score >= _fuzzyScoreThreshold).toList();

        filteredOrgs = fuzzyResults.map((result) {
          final index = orgNames.indexOf(result.choice);
          return orgs[index];
        }).toList();
      }

      orgs = filteredOrgs;
    }

    emit(
      state.copyWith(
        selectedType: newSelectedType,
        filteredOrganisations: _applySorting(orgs),
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
        selectedCollectGroup: state.selectedCollectGroup == selectedNow
            ? const CollectGroup.empty()
            : selectedNow,
      ),
    );
    emit(
      state.copyWith(
        status: OrganisationStatus.filtered,
        filteredOrganisations: _applySorting(
          state.filteredOrganisations,
        ),
      ),
    );
  }

  FutureOr<void> _onAddOrganisationToFavorites(
    AddOrganisationToFavorites event,
    Emitter<OrganisationState> emit,
  ) {
    final userGuid = _getUserGuid();
    final key = _getFavoritedOrganisationsKey(userGuid);
    final updatedFavorites = List<String>.from(state.favoritedOrganisations)
      ..add(event.nameSpace);
    _sharedPreferences.setStringList(key, updatedFavorites);
    emit(
      state.copyWith(favoritedOrganisations: updatedFavorites),
    );
    emit(
      state.copyWith(
        filteredOrganisations: _applySorting(
          state.filteredOrganisations,
        ),
      ),
    );
  }

  FutureOr<void> _onRemoveOrganisationFromFavorites(
    RemoveOrganisationFromFavorites event,
    Emitter<OrganisationState> emit,
  ) {
    final userGuid = _getUserGuid();
    final key = _getFavoritedOrganisationsKey(userGuid);
    final updatedFavorites = List<String>.from(state.favoritedOrganisations)
      ..remove(event.nameSpace);
    _sharedPreferences.setStringList(key, updatedFavorites);
    emit(
      state.copyWith(favoritedOrganisations: updatedFavorites),
    );
    emit(
      state.copyWith(
        filteredOrganisations: _applySorting(state.filteredOrganisations),
      ),
    );
  }

  Future<AccountType> _getAccountType(Country country) async {
    if (country.isBACS) {
      return AccountType.bacs;
    }
    if (country.isCreditCard) {
      return AccountType.creditCard;
    }
    return AccountType.sepa;
  }

  String _removeDiacritics(String string) => removeDiacritics(string);
}
