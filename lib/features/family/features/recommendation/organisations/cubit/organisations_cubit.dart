import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/repositories/organisations_repository.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/areas.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';
import 'package:givt_app/utils/utils.dart';

part 'organisations_state.dart';

class OrganisationsCubit extends Cubit<OrganisationsState> {
  OrganisationsCubit(this._organisationsRepository)
      : super(const OrganisationsInitialState());

  final OrganisationsRepository _organisationsRepository;

  Future<void> getRecommendedOrganisations({
    required Tag location,
    required List<Tag> interests,
    String? cityName,
    Duration fakeComputingExtraDelay = Duration.zero,
    int pageSize = 3,
    bool filterInterests = true,
  }) async {
    emit(const OrganisationsFetchingState());

    await Future<void>.delayed(fakeComputingExtraDelay);

    try {
      await AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.showCharitiesPressed,
        eventProperties: {
          AnalyticsHelper.interestKey:
              '${interests.map((e) => e.displayText).toList()}',
          AnalyticsHelper.locationKey: location.displayText,
        },
      );
      final response =
          await _organisationsRepository.getRecommendedOrganisations(
        location: location,
        cityName: cityName ?? '',
        interests: interests,
        pageSize: pageSize,
        filterInterests: filterInterests,
      );

      emit(OrganisationsFetchedState(organisations: response));
    } catch (error, stackTrace) {
      LoggingInfo.instance.error(
        'Error while fetching recommended organisations: $error',
        methodName: stackTrace.toString(),
      );

      emit(OrganisationsExternalErrorState(errorMessage: error.toString()));
    }
  }
}
