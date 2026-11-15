import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/features/give/utils/donation_submission_errors.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'give_event.dart';
part 'give_state.dart';

class GiveBloc extends Bloc<GiveEvent, GiveState> {
  GiveBloc(
    this._campaignRepository,
    this._givtRepository,
    this._collectGroupRepository,
  ) : super(const GiveState()) {
    on<GiveForYouSubmitDonations>(_forYouSubmitDonations);
  }

  final CampaignRepository _campaignRepository;
  final GivtRepository _givtRepository;
  final CollectGroupRepository _collectGroupRepository;

  @override
  void onTransition(Transition<GiveEvent, GiveState> transition) {
    log(transition.toString());
    super.onTransition(transition);
  }

  FutureOr<void> _forYouSubmitDonations(
    GiveForYouSubmitDonations event,
    Emitter<GiveState> emit,
  ) async {
    if (state.status == GiveStatus.readyToGive) {
      return;
    }
    emit(state.copyWith(status: GiveStatus.loading));
    try {
      if (event.donations.isEmpty) {
        emit(state.copyWith(status: GiveStatus.error));
        return;
      }

      final organisation = await _getOrganisation(event.nameSpace);

      await _campaignRepository.saveLastDonation(
        organisation,
      );

      var transactionIds = <int>[];
      try {
        LoggingInfo.instance.info('Submitting Givts (For You multi-goal)');
        transactionIds = await _givtRepository.submitGivts(
          guid: event.userGUID,
          body: {'donations': GivtTransaction.toApiJsonList(event.donations)},
        );
        await _handleAutoFavorites(event.nameSpace, event.userGUID);
      } on SocketException catch (e) {
        log(e.toString());
        emit(
          state.copyWith(
            organisation: organisation,
            status: GiveStatus.noInternetConnection,
          ),
        );
        return;
      } on GivtServerFailure catch (e, stackTrace) {
        if (_handleGivtServerFailure(e, stackTrace, emit, organisation)) {
          return;
        }
      } catch (e, stackTrace) {
        if (_handleDonationSubmissionTimeout(
          e,
          stackTrace,
          emit,
          organisation,
        )) {
          return;
        }
        rethrow;
      }

      emit(
        state.copyWith(
          status: GiveStatus.readyToGive,
          organisation: organisation,
          givtTransactions: event.donations,
          transactionIds: transactionIds,
          userGUID: event.userGUID,
          isForYouFlow: true,
          submitted: true,
        ),
      );
    } catch (e, stackTrace) {
      if (_handleDonationSubmissionTimeout(e, stackTrace, emit)) {
        return;
      }
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: GiveStatus.error));
      return;
    }
    emit(state.copyWith(status: GiveStatus.processed));
  }

  Future<Organisation> _getOrganisation(String mediumId) async {
    final organisation = await _campaignRepository.getOrganisation(mediumId);
    return organisation.copyWith(mediumId: mediumId);
  }

  bool _handleGivtServerFailure(
    GivtServerFailure e,
    StackTrace stackTrace,
    Emitter<GiveState> emit, [
    Organisation? organisation,
  ]) {
    final statusCode = e.statusCode;
    final body = e.body;
    log('StatusCode:$statusCode Body:$body');
    LoggingInfo.instance.warning(
      body.toString(),
      methodName: stackTrace.toString(),
    );
    if (statusCode == 408) {
      emit(
        state.copyWith(
          status: GiveStatus.submissionTimeout,
          organisation: organisation ?? state.organisation,
        ),
      );
      return true;
    }
    if (statusCode == 417) {
      emit(
        state.copyWith(
          status: GiveStatus.donatedToSameOrganisationInLessThan30Seconds,
        ),
      );
      return true;
    }
    emit(
      state.copyWith(status: GiveStatus.error),
    );
    return true;
  }

  bool _handleDonationSubmissionTimeout(
    Object error,
    StackTrace stackTrace,
    Emitter<GiveState> emit, [
    Organisation? organisation,
  ]) {
    if (!isDonationSubmissionTimeout(error)) {
      return false;
    }
    LoggingInfo.instance.warning(
      error.toString(),
      methodName: stackTrace.toString(),
    );
    emit(
      state.copyWith(
        status: GiveStatus.submissionTimeout,
        organisation: organisation ?? state.organisation,
      ),
    );
    return true;
  }

  /// Tracks donations to organizations and automatically adds an organization to favorites
  /// after a user gives to the same organization twice in a row (consecutive donations)
  Future<void> _handleAutoFavorites(String namespace, String userGUID) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final previousDonationKey = '${Util.previousDonationOrgKey}_$userGUID';
      final previousDonationOrg = prefs.getString(previousDonationKey) ?? '';

      final isConsecutiveDonation = namespace == previousDonationOrg;

      if (isConsecutiveDonation && previousDonationOrg.isNotEmpty) {
        final favoritesKey = '${Util.favoritedOrganisationsKey}$userGUID';
        final favoritedOrganisations = prefs.getStringList(favoritesKey) ?? [];

        if (!favoritedOrganisations.contains(namespace)) {
          favoritedOrganisations.add(namespace);
          await prefs.setStringList(favoritesKey, favoritedOrganisations);

          final collectGroupList = await _collectGroupRepository
              .getCollectGroupList();
          final orgName = collectGroupList
              .firstWhere(
                (org) => org.nameSpace == namespace,
                orElse: () => const CollectGroup.empty(),
              )
              .orgName;

          AnalyticsHelper.logEvent(
            eventName: AnalyticsEventName.favoriteAutoAdded,
            eventProperties: {
              'organisation_name': orgName,
              'organisation_namespace': namespace,
            },
          );
        }
      }

      await prefs.setString(previousDonationKey, namespace);
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
        'Error in auto-favorites: $e',
        methodName: stackTrace.toString(),
      );
    }
  }
}