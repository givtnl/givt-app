import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/overview/repositories/recurring_donations_repository.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';

part 'recurring_donations_state.dart';

class RecurringDonationsCubit extends Cubit<RecurringDonationsState> {
  RecurringDonationsCubit(
    this._recurringDonationsRepository,
    this._collectGroupRepository,
  ) : super(RecurringDonationsInitialState());

  final RecurringDonationsRepository _recurringDonationsRepository;
  final CollectGroupRepository _collectGroupRepository;

  Future<void> fetchRecurringDonations(String guid) async {
    emit(RecurringDonationsFetchingState());
    try {
      final response =
          await _recurringDonationsRepository.fetchRecurringDonations(guid);

      final collectGroups = await _collectGroupRepository.getCollectGroupList();

      for (var i = 0; i < response.length; i++) {
        final recurringDonation = response[i];
        final collectGroup = collectGroups.firstWhere(
          (element) => element.nameSpace == recurringDonation.namespace,
          orElse: () {
            log(
              'collection with namespase ${recurringDonation.namespace} not found',
            );
            return const CollectGroup.empty();
          },
        );

        final recurringDonationExt =
            recurringDonation.copyWith(collectGroup: collectGroup);

        response[i] = recurringDonationExt;
      }

      emit(RecurringDonationsFetchedState(recurringDonations: response));
    } catch (error, stackTrace) {
      LoggingInfo.instance.error(
        error.toString(),
        methodName: stackTrace.toString(),
      );
      emit(RecurringDonationsErrorState(error: error.toString()));
    }
  }
}
