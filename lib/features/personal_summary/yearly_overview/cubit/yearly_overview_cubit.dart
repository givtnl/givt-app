import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation.dart';
import 'package:givt_app/features/personal_summary/overview/models/summary_group_type.dart';
import 'package:givt_app/features/personal_summary/overview/models/summary_order_type.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/shared/models/summary_item.dart';
import 'package:givt_app/shared/repositories/repositories.dart';
import 'package:intl/intl.dart';

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
      final toDate = DateTime.parse(
        '${currentYear + 1}-01-01',
      ).toIso8601String();

      final previousYear = currentYear - 1;
      final fromPreviousDate = DateTime.parse(
        '$previousYear-01-01',
      ).toIso8601String();
      final toPreviousDate = DateTime.parse(
        '$previousYear-12-31',
      ).toIso8601String();

      final externalDonationsListPreviousYear = await _givtRepository
          .fetchExternalDonationSummary(
            fromDate: fromPreviousDate,
            tillDate: toPreviousDate,
          );

      final monthlyByOrganisationPreviousYear = await _givtRepository
          .fetchSummary(
            guid: guid,
            fromDate: fromPreviousDate,
            tillDate: toPreviousDate,
            orderType: SummaryOrderType.key.type,
            groupType: SummaryGroupType.perDestination.type,
          );

      final externalDonationsList = await _givtRepository
          .fetchExternalDonationSummary(
            fromDate: fromDate,
            tillDate: toDate,
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

      final externaDonationsPerMonth = _groupByMonth(externalDonationsList);

      emit(
        state.copyWith(
          status: YearlyOverviewStatus.loaded,
          externalDonations: externalDonationsList
              .map(
                (e) => SummaryItem(
                  key: e.description,
                  amount: e.amount,
                  count: 1,
                  taxDeductable: e.taxDeductible,
                ),
              )
              .toList(),
          monthlyByOrganisation: monthlyByOrganisation,
          externalDonationsPreviousYear: externalDonationsListPreviousYear
              .map(
                (e) => SummaryItem(
                  key: e.description,
                  amount: e.amount,
                  count: 1,
                  taxDeductable: e.taxDeductible,
                ),
              )
              .toList(),
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
      final tillDate = DateTime.parse(
        '${int.parse(state.year) + 1}-01-01',
      ).toIso8601String();
      final isSuccess = await _givtRepository.downloadYearlyOverview(
        fromDate: fromDate,
        toDate: tillDate,
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

  /// Groups external donations by month
  List<SummaryItem> _groupByMonth(
    List<ExternalDonation> donations,
  ) {
    final grouped = <String, Map<String, double>>{};
    final dateFormat = DateFormat('yyyy-MM');

    for (final donation in donations) {
      final date = DateTime.parse(donation.creationDate);
      final key = dateFormat.format(date);

      if (!grouped.containsKey(key)) {
        grouped[key] = {'amount': 0, 'count': 0};
      }
      grouped[key]!['amount'] = grouped[key]!['amount']! + donation.amount;
      grouped[key]!['count'] = grouped[key]!['count']! + 1;
    }

    return grouped.entries.map((entry) {
      return SummaryItem(
        key: entry.key,
        amount: entry.value['amount']!,
        count: entry.value['count']!,
        taxDeductable: false,
      );
    }).toList();
  }
}
