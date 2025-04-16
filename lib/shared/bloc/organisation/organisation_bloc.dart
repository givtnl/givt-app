import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:diacritic/diacritic.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/models/models.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'organisation_event.dart';
part 'organisation_state.dart';

// Minimum score threshold for fuzzy search results (0-100)
const int _fuzzyScoreThreshold = 70;

// Add a private field for the SharedPreferences key
const String _favoritedOrganisationsKey = 'favoritedOrganisations';
const String _lastSelectedOrganisationKey = 'lastSelectedOrganisation';

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
    on<OrganisationSortByFavoritesToggled>(
        _onOrganisationSortByFavoritesToggled);
  }

  final CollectGroupRepository _collectGroupRepository;
  final CampaignRepository _campaignRepository;
  final SharedPreferences _sharedPreferences;

  String _getFavoritedOrganisationsKey(String userGuid) {
    return '_favoritedOrganisationsKey_$userGuid';
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

  List<CollectGroup> _applyFavoriteSortingIfNeeded(
      List<CollectGroup> organisations) {
    // Create a copy of the list to avoid modifying the original
    final result = List<CollectGroup>.from(organisations);
    final selectedOrg = state.selectedCollectGroup;

    // Remove selected organization if it exists in the list
    final hasSelectedOrg = selectedOrg.nameSpace.isNotEmpty &&
        result.any((org) => org.nameSpace == selectedOrg.nameSpace);
    if (hasSelectedOrg) {
      result.removeWhere((org) => org.nameSpace == selectedOrg.nameSpace);
    }

    // Sort the list (by favorites or alphabetically)
    if (state.sortByFavorites) {
      result.sort((a, b) {
        final aIsFavorited = state.favoritedOrganisations.contains(a.nameSpace);
        final bIsFavorited = state.favoritedOrganisations.contains(b.nameSpace);
        return aIsFavorited == bIsFavorited
            ? a.orgName.compareTo(b.orgName)
            : (aIsFavorited ? -1 : 1);
      });
    } else {
      result.sort((a, b) => a.orgName.compareTo(b.orgName));
    }

    // Add selected organization at the top if it existed
    if (hasSelectedOrg) {
      result.insert(0, selectedOrg);
    }

    return result;
  }

  // Helper method to get type-filtered organizations based on the selected type
  List<CollectGroup> _getTypeFilteredOrganisations(int selectedType) {
    // If no type filter is active, return all organizations
    if (selectedType == CollectGroupType.none.index) {
      return state.organisations;
    }

    // Otherwise, filter by the selected type
    return state.organisations
        .where((org) => org.type.index == selectedType)
        .toList();
  }

  // Helper method to filter organizations by search query
  List<CollectGroup> _filterOrganisationsByQuery(
    List<CollectGroup> organisations,
    String query,
  ) {
    if (query.isEmpty) {
      return organisations;
    }

    // First try exact substring matching
    final exactMatches = organisations
        .where(
          (org) => _removeDiacritics(org.orgName.toLowerCase()).contains(query),
        )
        .toList();

    // If we have exact matches, use those
    if (exactMatches.isNotEmpty) {
      return exactMatches;
    }

    // If no exact matches, use fuzzy matching
    final orgNames = organisations
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
    return fuzzyResults.map((result) {
      final index = orgNames.indexOf(result.choice);
      return organisations[index];
    }).toList();
  }

  // Helper method to ensure the selected organization is always at the top of results
  List<CollectGroup> _ensureSelectedOrganisationOnTop(
    List<CollectGroup> filteredResults,
    CollectGroup selectedGroup,
    List<CollectGroup> typeFilteredOrgs,
    String query,
  ) {
    // Check if there's a currently selected organization
    if (selectedGroup.nameSpace.isEmpty) {
      return filteredResults;
    }

    // Find the selected organization in the full organization list, regardless of type
    final selectedOrgInAllOrgs = state.organisations.firstWhere(
      (org) => org.nameSpace == selectedGroup.nameSpace,
      orElse: () => const CollectGroup.empty(),
    );

    // If it exists in the full list, use it
    if (selectedOrgInAllOrgs.nameSpace.isNotEmpty) {
      // Remove the selected organization if it exists in the filtered results
      filteredResults.removeWhere(
          (org) => org.nameSpace == selectedOrgInAllOrgs.nameSpace);

      // Always add the selected organization at the top
      filteredResults.insert(0, selectedOrgInAllOrgs);

      // Log and track analytics only if it wouldn't normally appear in results
      if (query.isNotEmpty &&
              !_removeDiacritics(selectedOrgInAllOrgs.orgName.toLowerCase())
                  .contains(query) ||
          (state.selectedType != CollectGroupType.none.index &&
              selectedOrgInAllOrgs.type.index != state.selectedType)) {
        LoggingInfo.instance.info(
            'Currently selected organization "${selectedOrgInAllOrgs.orgName}" added to search results despite not matching filter criteria');

        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.changeNameSubmitted,
          eventProperties: {
            'included_in_search': 'force_included',
            'organisation_name': selectedOrgInAllOrgs.orgName,
            'filter_type': state.selectedType,
            'organisation_type': selectedOrgInAllOrgs.type.index,
            'search_query': query,
          },
        );
      }
    }

    return filteredResults;
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

      // Check for a previously selected organization
      final lastSelectedNameSpace =
          _sharedPreferences.getString(_lastSelectedOrganisationKey);

      if (lastSelectedNameSpace != null && lastSelectedNameSpace.isNotEmpty) {
        // Find the previously selected organization in the current list
        final lastSelectedOrg = organisations.firstWhere(
          (org) => org.nameSpace == lastSelectedNameSpace,
          orElse: () => const CollectGroup.empty(),
        );

        // If found and belongs to the current type (or we're showing all types), set it as the selected organization
        if (lastSelectedOrg.nameSpace.isNotEmpty &&
            (event.type == CollectGroupType.none.index ||
                lastSelectedOrg.type.index == event.type)) {
          selectedGroup = lastSelectedOrg;
        }
      }

      if (event.showLastDonated) {
        final lastDonatedOrganisation =
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
          status: OrganisationStatus.filtered,
          organisations: organisations,
          filteredOrganisations: organisations,
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
          filteredOrganisations: organisations,
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
      final typeFilteredOrgs =
          _getTypeFilteredOrganisations(state.selectedType);

      // Apply query filtering and ensure selected org stays on top
      final filteredResults = _ensureSelectedOrganisationOnTop(
        _filterOrganisationsByQuery(typeFilteredOrgs, query),
        state.selectedCollectGroup,
        typeFilteredOrgs,
        query,
      );

      emit(state.copyWith(
        status: OrganisationStatus.filtered,
        filteredOrganisations: _applyFavoriteSortingIfNeeded(filteredResults),
        selectedCollectGroup: state.selectedCollectGroup,
        previousSearchQuery: event.query,
      ));
    } catch (e, stackTrace) {
      LoggingInfo.instance
          .error(e.toString(), methodName: stackTrace.toString());
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
    // Get organizations filtered by the selected type
    var orgs = _getTypeFilteredOrganisations(newSelectedType);
    CollectGroup selectedOrg = state.selectedCollectGroup;

    // Try to restore the last selected organization for this type
    if (newSelectedType != CollectGroupType.none.index) {
      final userGuid = _getUserGuid();
      final key = _lastSelectedOrganisationKey;
      final lastSelectedNameSpace = _sharedPreferences.getString(key);

      if (lastSelectedNameSpace != null && lastSelectedNameSpace.isNotEmpty) {
        // Find the previously selected organization in the current filtered list
        final lastSelectedOrg = orgs.firstWhere(
          (org) => org.nameSpace == lastSelectedNameSpace,
          orElse: () => const CollectGroup.empty(),
        );

        // If found, update the selection
        if (lastSelectedOrg.nameSpace.isNotEmpty) {
          selectedOrg = lastSelectedOrg;
        }
      }
    }

    // Apply search filter if there's an active query
    if (state.previousSearchQuery.isNotEmpty) {
      final query = _removeDiacritics(state.previousSearchQuery.toLowerCase());
      orgs = _filterOrganisationsByQuery(orgs, query);
    }

    // Ensure selected organization is at the top
    orgs = _ensureSelectedOrganisationOnTop(
        orgs,
        selectedOrg,
        _getTypeFilteredOrganisations(newSelectedType),
        state.previousSearchQuery.toLowerCase());

    emit(state.copyWith(
      selectedType: newSelectedType,
      selectedCollectGroup: selectedOrg,
      filteredOrganisations: _applyFavoriteSortingIfNeeded(orgs),
    ));
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

    // Store selection to SharedPreferences if it's a new selection
    if (state.selectedCollectGroup != selectedNow) {
      // Using a single key for storing the selected organization, without the type
      _sharedPreferences.setString(
          _lastSelectedOrganisationKey, event.mediumId);
    }

    emit(
      state.copyWith(
        status: OrganisationStatus.filtered,
        selectedCollectGroup: state.selectedCollectGroup == selectedNow
            ? const CollectGroup.empty()
            : selectedNow,
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
    emit(state.copyWith(favoritedOrganisations: updatedFavorites));
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
    emit(state.copyWith(favoritedOrganisations: updatedFavorites));
  }

  FutureOr<void> _onOrganisationSortByFavoritesToggled(
    OrganisationSortByFavoritesToggled event,
    Emitter<OrganisationState> emit,
  ) {
    emit(state.copyWith(sortByFavorites: event.sortByFavorites));
    _handleTypeChange(
      state.selectedType,
      emit,
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
