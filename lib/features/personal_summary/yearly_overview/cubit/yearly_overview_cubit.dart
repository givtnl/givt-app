import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/personal_summary/overview/models/summary_group_type.dart';
import 'package:givt_app/features/personal_summary/overview/models/summary_order_type.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/shared/repositories/repositories.dart';

part 'yearly_overview_state.dart';

class YearlyOverviewCubit extends Cubit<YearlyOverviewState> {
  YearlyOverviewCubit(
    this._givtRepository,
  ) : super(YearlyOverviewState(year: DateTime.now().year.toString()));

  final GivtRepository _givtRepository;

  Future<void> init({
    required String year,
    required String guid,
  }) async {
    try {
      emit(state.copyWith(status: YearlyOverviewStatus.loading));

      final currentYear = int.parse(year);
      final fromDate = DateTime.parse('$year-01-01').toIso8601String();
      final toDate =
          DateTime.parse('${currentYear + 1}-01-01').toIso8601String();

      final previousYear = currentYear - 1;
      final fromPreviousDate =
          DateTime.parse('$previousYear-01-01').toIso8601String();
      final toPreviousDate =
          DateTime.parse('$previousYear-12-31').toIso8601String();

      final externalDonationsPreviousYear =
          await _givtRepository.fetchExternalDonationSummary(
        fromDate: fromPreviousDate,
        tillDate: toPreviousDate,
        orderType: SummaryOrderType.key.type,
        groupType: SummaryGroupType.perDestination.type,
      );

      final monthlyByOrganisationPreviousYear =
          await _givtRepository.fetchSummary(
        guid: guid,
        fromDate: fromPreviousDate,
        tillDate: toPreviousDate,
        orderType: SummaryOrderType.key.type,
        groupType: SummaryGroupType.perDestination.type,
      );

      final externaDonations =
          await _givtRepository.fetchExternalDonationSummary(
        fromDate: fromDate,
        tillDate: toDate,
        orderType: SummaryOrderType.key.type,
        groupType: SummaryGroupType.perDestination.type,
      );

      final monthlyByOrganisation = await _givtRepository.fetchSummary(
        guid: guid,
        fromDate: fromDate,
        tillDate: toDate,
        orderType: SummaryOrderType.key.type,
        groupType: SummaryGroupType.perDestination.type,
      );

      final donationsPerMonth = await _givtRepository.fetchSummary(
        guid: guid,
        fromDate: fromDate,
        tillDate: toDate,
        orderType: SummaryOrderType.key.type,
        groupType: SummaryGroupType.perMonth.type,
      );

      final externaDonationsPerMonth =
          await _givtRepository.fetchExternalDonationSummary(
        fromDate: fromDate,
        tillDate: toDate,
        orderType: SummaryOrderType.key.type,
        groupType: SummaryGroupType.perMonth.type,
      );

      emit(
        state.copyWith(
          status: YearlyOverviewStatus.loaded,
          externalDonations: externaDonations,
          monthlyByOrganisation: monthlyByOrganisation,
          externalDonationsPreviousYear: externalDonationsPreviousYear,
          monthlyByOrganisationPreviousYear: monthlyByOrganisationPreviousYear,
          externalDonationsPerMonth: externaDonationsPerMonth,
          monthlyByOrganisationPerMonth: donationsPerMonth,
          year: year,
        ),
      );
    } on GivtServerFailure catch (e, stackTrace) {
      LoggingInfo.instance.error(
        e.body.toString(),
        methodName: stackTrace.toString(),
      );
      emit(
        state.copyWith(
          status: YearlyOverviewStatus.error,
        ),
      );
    }
  }

  Future<void> downloadSummary() async {
    emit(state.copyWith(status: YearlyOverviewStatus.loading));
    try {
      final fromDate = DateTime.parse('${state.year}-01-01').toIso8601String();
      final tillDate = DateTime.parse('${int.parse(state.year) + 1}-01-01')
          .toIso8601String();
      final isSuccess = await _givtRepository.downloadYearlyOverview(
        body: {'fromDate': fromDate, 'tillDate': tillDate},
      );
      if (!isSuccess) {
        emit(state.copyWith(status: YearlyOverviewStatus.error));
        return;
      }
      emit(state.copyWith(status: YearlyOverviewStatus.summaryDownloaded));
    } on GivtServerFailure catch (e, stackTrace) {
      LoggingInfo.instance.error(
        e.body.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: YearlyOverviewStatus.error));
    } on SocketException {
      emit(state.copyWith(status: YearlyOverviewStatus.noInternet));
    }
  }
}
