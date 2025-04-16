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
import 'package:givt_app/features/overview/models/givt.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'organisation_event.dart';
part 'organisation_state.dart';

// Minimum score threshold for fuzzy search results (0-100)
const int _fuzzyScoreThreshold = 70;

// Add a private field for the SharedPreferences key
const String _favoritedOrganisationsKey = 'favoritedOrganisations';
const String _lastSelectedOrganisationKey = 'lastSelectedOrganisation';
const String _organisationDonationCountsKey = 'organisationDonationCounts';
const int _autoFavoriteThreshold = 2;

class OrganisationBloc extends Bloc<OrganisationEvent, OrganisationState> {
  OrganisationBloc(
    this._collectGroupRepository,
    this._campaignRepository,
    this._sharedPreferences,
    this._givtRepository,
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
  final GivtRepository _givtRepository;

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
    if (state.sortByFavorites) {
      organisations.sort((CollectGroup a, CollectGroup b) {
        final aIsFavorited = state.favoritedOrganisations.contains(a.nameSpace);
        final bIsFavorited = state.favoritedOrganisations.contains(b.nameSpace);
        if (aIsFavorited && !bIsFavorited) return -1;
        if (!aIsFavorited && bIsFavorited) return 1;
        return a.orgName.compareTo(b.orgName);
      });
    } else {
      // sort by name if not sorting by favorites
      organisations.sort((CollectGroup a, CollectGroup b) {
        return a.orgName.compareTo(b.orgName);
      });
    }
    return organisations;
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

      // If GivtRepository is provided, fetch givts and analyze for auto-favoriting
      if (_givtRepository != null) {
        try {
          final givts = await _givtRepository!.fetchGivts();

          // Count organization occurrences in successful donations
          final donationCounts = <String, int>{};
          for (final givt in givts) {
            if (givt.mediumId.isNotEmpty && givt.status >= 1) {
              donationCounts[givt.mediumId] =
                  (donationCounts[givt.mediumId] ?? 0) + 1;
            }
          }

          // Auto-favorite organizations that appear 2 or more times
          for (final entry in donationCounts.entries) {
            if (entry.value >= _autoFavoriteThreshold &&
                !favoritedOrganisations.contains(entry.key) &&
                entry.key.isNotEmpty) {
              // Find organization name from the collected organizations
              final org = organisations.firstWhere(
                (org) => org.nameSpace == entry.key,
                orElse: () => const CollectGroup.empty(),
              );

              if (org.nameSpace.isNotEmpty) {
                // Add to favorites in SharedPreferences
                final updatedFavorites =
                    List<String>.from(favoritedOrganisations)..add(entry.key);
                _sharedPreferences.setStringList(key, updatedFavorites);
                favoritedOrganisations.add(entry.key);

                // Log the auto-favorite action
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.organisationFavoriteToggled,
                  eventProperties: {
                    'organisation_name': org.orgName,
                    'organisation_id': entry.key,
                    'is_favorited': true,
                    'auto_favorited': true,
                    'donation_count': entry.value,
                  },
                );

                // Update donation count in SharedPreferences
                final countsKey = '${_organisationDonationCountsKey}_$userGuid';
                Map<String, dynamic> storedCounts = {};
                final countsString = _sharedPreferences.getString(countsKey);
                if (countsString != null && countsString.isNotEmpty) {
                  storedCounts =
                      jsonDecode(countsString) as Map<String, dynamic>;
                }
                storedCounts[entry.key] = entry.value;
                _sharedPreferences.setString(
                    countsKey, jsonEncode(storedCounts));
              }
            }
          }
        } catch (e, stackTrace) {
          // Just log the error but don't throw it to continue with the rest of the organizations fetch
          LoggingInfo.instance.error(
            'Failed to auto-favorite organizations from givts: ${e.toString()}',
            methodName: stackTrace.toString(),
          );
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
            filteredOrganisations:
                _applyFavoriteSortingIfNeeded(typeFilteredOrgs),
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
            filteredOrganisations: _applyFavoriteSortingIfNeeded(exactMatches),
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
          filteredOrganisations: _applyFavoriteSortingIfNeeded(fuzzyMatches),
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
        filteredOrganisations: _applyFavoriteSortingIfNeeded(orgs),
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

  // Track donation counts per organization and auto-favorite organizations with >= 2 donations
  void trackDonationAndAutoFavorite(String nameSpace) {
    if (nameSpace.isEmpty) return;

    final userGuid = _getUserGuid();
    final countsKey = '${_organisationDonationCountsKey}_$userGuid';

    // Get current donation counts from SharedPreferences
    Map<String, dynamic> donationCounts = {};
    final countsString = _sharedPreferences.getString(countsKey);
    if (countsString != null && countsString.isNotEmpty) {
      donationCounts = jsonDecode(countsString) as Map<String, dynamic>;
    }

    // Increment donation count for this organization
    final currentCount = (donationCounts[nameSpace] as int?) ?? 0;
    final newCount = currentCount + 1;
    donationCounts[nameSpace] = newCount;

    // Save updated counts back to SharedPreferences
    _sharedPreferences.setString(countsKey, jsonEncode(donationCounts));

    // Auto-favorite if threshold is reached
    if (newCount >= _autoFavoriteThreshold &&
        !state.favoritedOrganisations.contains(nameSpace)) {
      // Add to favorites
      final favKey = _getFavoritedOrganisationsKey(userGuid);
      final updatedFavorites = List<String>.from(state.favoritedOrganisations)
        ..add(nameSpace);
      _sharedPreferences.setStringList(favKey, updatedFavorites);

      // Get organization name for analytics
      final orgName = state.organisations
          .firstWhere(
            (org) => org.nameSpace == nameSpace,
            orElse: () => const CollectGroup.empty(),
          )
          .orgName;

      // Log the auto-favorite action
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.organisationFavoriteToggled,
        eventProperties: {
          'organisation_name': orgName,
          'organisation_id': nameSpace,
          'is_favorited': true,
          'auto_favorited': true,
          'donation_count': newCount,
        },
      );

      // Update state
      add(AddOrganisationToFavorites(nameSpace));
    }
  }

  // Get donation count for an organization
  int getDonationCount(String nameSpace) {
    if (nameSpace.isEmpty) return 0;

    final userGuid = _getUserGuid();
    final countsKey = '${_organisationDonationCountsKey}_$userGuid';

    // Get current donation counts from SharedPreferences
    final countsString = _sharedPreferences.getString(countsKey);
    if (countsString == null || countsString.isEmpty) {
      return 0;
    }

    final donationCounts = jsonDecode(countsString) as Map<String, dynamic>;
    return (donationCounts[nameSpace] as int?) ?? 0;
  }
}
