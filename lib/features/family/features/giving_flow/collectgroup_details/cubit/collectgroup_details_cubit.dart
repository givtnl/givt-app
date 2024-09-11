import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/giving_flow/collectgroup_details/models/collectgroup_details.dart';
import 'package:givt_app/features/family/features/giving_flow/collectgroup_details/repositories/organisation_details_repository.dart';
import 'package:givt_app/utils/utils.dart';

part 'collectgroup_details_state.dart';

class CollectGroupDetailsCubit extends Cubit<OrganisationDetailsState> {
  CollectGroupDetailsCubit(this._organisationRepository)
      : super(const OrganisationDetailsInitialState());

  final OrganisationDetailsRepository _organisationRepository;
  static const String defaultMediumId =
      'NjFmN2VkMDE1NTUzMDEyMmMwMDAuZmMwMDAwMDAwMDAx';

  // emits true for success, false for failure
  Future<bool> getOrganisationDetails(String mediumId) async {
    emit(const OrganisationDetailsLoadingState());

    try {
      final response =
          await _organisationRepository.fetchOrganisationDetails(mediumId);

      emit(
        OrganisationDetailsSetState(
          collectgroup: response,
          mediumId: mediumId,
        ),
      );

      unawaited(
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.organisationSelected,
          eventProperties: {
            'goal_name': response.name,
          },
        ),
      );
      return true;
    } catch (error, stackTrace) {
      LoggingInfo.instance.error(
        'Error while fetching organisation details: $error',
        methodName: stackTrace.toString(),
      );
      emit(OrganisationDetailsErrorState(mediumId: mediumId));
      return false;
    }
  }
}
