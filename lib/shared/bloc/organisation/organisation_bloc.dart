import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:diacritic/diacritic.dart';
import 'package:equatable/equatable.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fuzzywuzzy/model/extracted_result.dart';
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

    on<OrganisationAllocationFilterChanged>(_onAllocationFilterChanged);
    on<OrganisationDateFilterChanged>(_onDateFilterChanged);
    on<OrganisationNonAllocatedFilterToggled>(_onNonAllocatedFilterToggled);
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
    List<CollectGroup> organisations, {
    String? searchQuery,
  }) {
    // Always sort the selected group to the top
    organisations.sort((CollectGroup a, CollectGroup b) {
      if (a == state.selectedCollectGroup &&
          a.orgName == lastDonatedOrganisation.organisationName) {
        return -1;
      }
      if (b == state.selectedCollectGroup &&
          b.orgName == lastDonatedOrganisation.organisationName) {
        return 1;
      }

      // Then sort by search query match if there's an active search
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = _removeDiacritics(searchQuery.toLowerCase());
        final aName = _removeDiacritics(a.orgName.toLowerCase());
        final bName = _removeDiacritics(b.orgName.toLowerCase());
        
        final aMatchesQuery = aName.contains(query);
        final bMatchesQuery = bName.contains(query);
        
        if (aMatchesQuery && !bMatchesQuery) return -1;
        if (!aMatchesQuery && bMatchesQuery) return 1;
      }

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
      emit(
        state.copyWith(
          previousSearchQuery: event.query,
        ),
      );
      
      _applyAllFilters(emit);
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: OrganisationStatus.error));
    }
  }

  /// Filters a list of organizations by query, with support for "Stichting" prefix handling.
  /// Returns organizations that match either the full query or the query without "stichting " prefix.
  List<CollectGroup> _filterOrganisationsByQuery({
    required String query,
    required List<CollectGroup> organisations,
  }) {
    final alternativeQuery = _getAlternativeQueryWithoutStichting(query);

    // First try exact substring matching
    final exactMatches = _getExactMatches(
      query: query,
      alternativeQuery: alternativeQuery,
      organisations: organisations,
    );

    if (exactMatches.isNotEmpty) {
      return exactMatches;
    }

    // If no exact matches, use fuzzy matching
    return _getFuzzyMatches(
      query: query,
      alternativeQuery: alternativeQuery,
      organisations: organisations,
    );
  }

  /// Returns organizations that contain the query or alternative query as a substring.
  /// Results are sorted with organizations matching the original query first.
  List<CollectGroup> _getExactMatches({
    required String query,
    required String? alternativeQuery,
    required List<CollectGroup> organisations,
  }) {
    final results = organisations
        .where(
          (org) {
            final orgName = _removeDiacritics(org.orgName.toLowerCase());
            return orgName.contains(query) ||
                (alternativeQuery != null && orgName.contains(alternativeQuery));
          },
        )
        .toList();
    
    // Sort results: organizations matching the original query first
    results.sort((a, b) {
      final aName = _removeDiacritics(a.orgName.toLowerCase());
      final bName = _removeDiacritics(b.orgName.toLowerCase());
      
      final aMatchesOriginal = aName.contains(query);
      final bMatchesOriginal = bName.contains(query);
      
      if (aMatchesOriginal && !bMatchesOriginal) return -1;
      if (!aMatchesOriginal && bMatchesOriginal) return 1;
      return 0;
    });
    
    return results;
  }

  /// Returns organizations that match the query or alternative query using fuzzy matching.
  /// Results are combined, deduplicated, and sorted by match score.
  List<CollectGroup> _getFuzzyMatches({
    required String query,
    required String? alternativeQuery,
    required List<CollectGroup> organisations,
  }) {
    final orgNames = organisations
        .map((org) => _removeDiacritics(org.orgName.toLowerCase()))
        .toList();

    // Extract fuzzy matched results for original query
    final fuzzyResults = extractAllSorted<String>(
      query: query,
      choices: orgNames,
    ).where((result) => result.score >= _fuzzyScoreThreshold).toList();

    // If we have an alternative query, also try fuzzy matching with it
    final alternativeFuzzyResults = alternativeQuery != null
        ? extractAllSorted<String>(
            query: alternativeQuery,
            choices: orgNames,
          ).where((result) => result.score >= _fuzzyScoreThreshold).toList()
        : <ExtractedResult<String>>[];

    // Combine and deduplicate results by index, keeping the best score for each organization
    // Prioritize original query results over alternative query results when scores are equal
    final combinedResults = <int, ({ExtractedResult<String> result, bool isOriginal})>{};
    
    // Process original query results first (they get priority)
    for (final result in fuzzyResults) {
      final existing = combinedResults[result.index];
      if (existing == null || result.score > existing.result.score) {
        combinedResults[result.index] = (result: result, isOriginal: true);
      }
    }
    
    // Then process alternative query results, only updating if score is better
    for (final result in alternativeFuzzyResults) {
      final existing = combinedResults[result.index];
      if (existing == null || result.score > existing.result.score) {
        combinedResults[result.index] = (result: result, isOriginal: false);
      }
    }

    // Sort by score and map back to organization objects
    final sortedResults = combinedResults.values.toList()
      ..sort((a, b) {
        // First sort by score (descending)
        final scoreComparison = b.result.score.compareTo(a.result.score);
        if (scoreComparison != 0) return scoreComparison;
        
        // If scores are equal, prioritize original query results
        if (a.isOriginal && !b.isOriginal) return -1;
        if (!a.isOriginal && b.isOriginal) return 1;
        return 0;
      });

    return sortedResults.map((entry) {
      return organisations[entry.result.index];
    }).toList();
  }

  /// Returns a query without "stichting " prefix if the query starts with it.
  /// Returns null if the query doesn't start with "stichting ".
  /// Works case-insensitively (e.g., "Stichting" or "STICHTING" also work).
  String? _getAlternativeQueryWithoutStichting(String query) {
    const stichtingPrefix = 'stichting ';
    final queryLower = query.toLowerCase();
    if (queryLower.startsWith(stichtingPrefix)) {
      final withoutStichting = query.substring(stichtingPrefix.length).trim();
      return withoutStichting.isNotEmpty ? withoutStichting : null;
    }
    return null;
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
    emit(
      state.copyWith(
        selectedType: newSelectedType,
      ),
    );
    
    _applyAllFilters(emit);
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

  FutureOr<void> _onAllocationFilterChanged(
    OrganisationAllocationFilterChanged event,
    Emitter<OrganisationState> emit,
  ) {
    emit(state.copyWith(status: OrganisationStatus.loading));
    
    // Toggle allocation filter - if the same allocation is selected, clear it
    final newAllocation = state.selectedAllocation == event.allocationName
        ? null
        : event.allocationName;
    
    emit(
      state.copyWith(
        selectedAllocation: newAllocation,
        showOnlyNonAllocated: false, // Clear non-allocated filter when selecting an allocation
      ),
    );
    
    _applyAllFilters(emit);
  }

  FutureOr<void> _onDateFilterChanged(
    OrganisationDateFilterChanged event,
    Emitter<OrganisationState> emit,
  ) {
    emit(state.copyWith(status: OrganisationStatus.loading));
    
    emit(
      state.copyWith(
        filterStartDate: event.startDate,
        filterEndDate: event.endDate,
      ),
    );
    
    _applyAllFilters(emit);
  }

  FutureOr<void> _onNonAllocatedFilterToggled(
    OrganisationNonAllocatedFilterToggled event,
    Emitter<OrganisationState> emit,
  ) {
    emit(state.copyWith(status: OrganisationStatus.loading));
    
    emit(
      state.copyWith(
        showOnlyNonAllocated: !state.showOnlyNonAllocated,
        selectedAllocation: null, // Clear allocation filter when toggling non-allocated
      ),
    );
    
    _applyAllFilters(emit);
  }

  void _applyAllFilters(Emitter<OrganisationState> emit) {
    var filteredOrgs = state.organisations;

    // Apply type filter
    if (state.selectedType != CollectGroupType.none.index) {
      filteredOrgs = filteredOrgs
          .where((org) => org.type.index == state.selectedType)
          .toList();
    }

    // Apply search query filter
    if (state.previousSearchQuery.isNotEmpty) {
      final query = _removeDiacritics(state.previousSearchQuery.toLowerCase());
      filteredOrgs = _filterOrganisationsByQuery(
        query: query,
        organisations: filteredOrgs,
      );
    }

    // Apply allocation filters
    if (state.showOnlyNonAllocated) {
      // Show only organizations without allocations
      filteredOrgs = filteredOrgs
          .where((org) => org.multiUseAllocations.isEmpty)
          .toList();
    } else if (state.selectedAllocation != null) {
      // Show only organizations with the selected allocation
      filteredOrgs = filteredOrgs
          .where(
            (org) => org.multiUseAllocations.any(
              (allocation) => allocation.name == state.selectedAllocation,
            ),
          )
          .toList();
    }

    // Apply date filter
    if (state.filterStartDate != null || state.filterEndDate != null) {
      filteredOrgs = filteredOrgs.where((org) {
        if (org.multiUseAllocations.isEmpty) {
          return false; // Exclude orgs without allocations when date filtering
        }

        return org.multiUseAllocations.any((allocation) {
          try {
            final allocStart = DateTime.parse(allocation.dtBeginCron);
            final allocEnd = DateTime.parse(allocation.dtEndCron);

            if (state.filterStartDate != null &&
                allocEnd.isBefore(state.filterStartDate!)) {
              return false;
            }

            if (state.filterEndDate != null &&
                allocStart.isAfter(state.filterEndDate!)) {
              return false;
            }

            return true;
          } catch (e) {
            // If date parsing fails, exclude the organization
            return false;
          }
        });
      }).toList();
    }

    emit(
      state.copyWith(
        status: OrganisationStatus.filtered,
        filteredOrganisations: _applySorting(filteredOrgs),
      ),
    );
  }
}
