import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/models.dart';
import 'package:givt_app/features/personal_summary/overview/models/summary_group_type.dart';
import 'package:givt_app/features/personal_summary/overview/models/summary_order_type.dart';
import 'package:givt_app/shared/models/summary_item.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/shared/repositories/repositories.dart';
import 'package:intl/intl.dart';

part 'personal_summary_event.dart';
part 'personal_summary_state.dart';

class PersonalSummaryBloc
    extends Bloc<PersonalSummaryEvent, PersonalSummaryState> {
  PersonalSummaryBloc({
    required this.givtRepo,
    required UserExt loggedInUserExt,
  }) : super(
          PersonalSummaryState(
            loggedInUserExt: loggedInUserExt,
            dateTime: DateTime(DateTime.now().year, DateTime.now().month)
                .toIso8601String(),
          ),
        ) {
    on<PersonalSummaryInit>(_onPersonalSummaryInit);
    on<PersonalSummaryMonthChange>(_onPersonalSummaryMonthChange);
  }
  final GivtRepository givtRepo;

  FutureOr<void> _onPersonalSummaryInit(
    PersonalSummaryInit event,
    Emitter<PersonalSummaryState> emit,
  ) async {
    emit(state.copyWith(status: PersonalSummaryStatus.loading));
    final now = DateTime.parse(state.dateTime);
    final firstDayOfMonth = DateTime(now.year, now.month);
    final untilDate = DateTime(now.year, now.month + 1);
    try {
      final monthlyGivts = await _fetchMonthlyGivts(
        fromDate: firstDayOfMonth.toIso8601String(),
        tillDate: untilDate.toIso8601String(),
      );

      final annualSummaryGivts = await _fetchAnnualSummaryGivts(
        tillDate: untilDate.toIso8601String(),
      );

      final externalDonations = await _fetchExternalDonations(
        fromDate: firstDayOfMonth.toIso8601String(),
        tillDate: untilDate.toIso8601String(),
      );
      emit(
        state.copyWith(
          status: PersonalSummaryStatus.success,
          monthlyGivts: monthlyGivts,
          annualGivts: annualSummaryGivts,
          pastTwelveMonths: await _fetchPastTwelveMonths(),
          externalDonations: externalDonations,
        ),
      );
    } on GivtServerFailure catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(
        state.copyWith(
          status: PersonalSummaryStatus.error,
          error: e.body.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onPersonalSummaryMonthChange(
    PersonalSummaryMonthChange event,
    Emitter<PersonalSummaryState> emit,
  ) async {
    emit(state.copyWith(status: PersonalSummaryStatus.loading));
    var current = DateTime.parse(state.dateTime);
    if (event.increase) {
      if (current.month == 12) {
        current = DateTime(current.year + 1, 1, 31);
      } else {
        current = DateTime(current.year, current.month + 2)
            .subtract(const Duration(days: 1));
      }
    }
    if (event.increase == false) {
      if (current.month == 1) {
        current = DateTime(current.year - 1, 12, 31);
      } else {
        current = DateTime(current.year, current.month)
            .subtract(const Duration(days: 1));
      }
    }

    final fromDate = DateTime(current.year, current.month);
    final untilDate = DateTime(current.year, current.month + 1);
    try {
      final monthlyGivts = await _fetchMonthlyGivts(
        fromDate: fromDate.toIso8601String(),
        tillDate: untilDate.toIso8601String(),
      );

      final externalDonations = await givtRepo.fetchExternalDonations(
        fromDate: fromDate.toIso8601String(),
        tillDate: untilDate.toIso8601String(),
      );
      emit(
        state.copyWith(
          status: PersonalSummaryStatus.success,
          monthlyGivts: monthlyGivts,
          externalDonations: externalDonations,
          dateTime: fromDate.toIso8601String(),
        ),
      );
    } on GivtServerFailure catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(
        state.copyWith(
          status: PersonalSummaryStatus.error,
          error: e.body.toString(),
        ),
      );
    }
  }

  Future<List<SummaryItem>> _fetchAnnualSummaryGivts({
    required String tillDate,
  }) async {
    final annualGivts = await givtRepo.fetchSummary(
      guid: state.loggedInUserExt.guid,
      fromDate: DateTime(2017).toIso8601String(),
      tillDate: tillDate,
      orderType: SummaryOrderType.key.type,
      groupType: SummaryGroupType.perYear.type,
    );
    return annualGivts;
  }

  /// Fetches monthly givts and sorts them by donation date
  /// in descending order.
  Future<List<SummaryItem>> _fetchMonthlyGivts({
    required String fromDate,
    required String tillDate,
  }) async {
    final monthlyGivts = await givtRepo.fetchSummary(
      guid: state.loggedInUserExt.guid,
      fromDate: fromDate,
      tillDate: tillDate,
      orderType: SummaryOrderType.donationDate.type,
      groupType: SummaryGroupType.perDestination.type,
    );
    return monthlyGivts;
  }

  /// Fetches past twelve months and sorts them by creation date
  Future<List<SummaryItem>> _fetchPastTwelveMonths() async {
    final today = DateTime.now();

    final fromDate = DateTime(today.year, today.month - 11).toIso8601String();
    final tillDate = DateTime(
      today.year,
      today.month + 1,
      today.day,
    ).toIso8601String();
    var pastTwelveMonths = await givtRepo.fetchSummary(
      guid: state.loggedInUserExt.guid,
      fromDate: fromDate,
      tillDate: tillDate,
      orderType: SummaryOrderType.sum.type,
      groupType: SummaryGroupType.perMonth.type,
    );

    pastTwelveMonths = _checkForMissingMonths(pastTwelveMonths);

    final externalDonations = await _fetchExternalDonations(
      fromDate: fromDate,
      tillDate: tillDate,
    );

    final pastTwelveMonthsWithExternalDonations = <SummaryItem>[];
    for (var element in pastTwelveMonths) {
      final donation = externalDonations.where(
        (x) => x.creationDate.contains(element.key),
      );
      element = element.copyWith(
        amount: element.amount +
            donation.fold(
              element.amount,
              (previousValue, element) => previousValue + element.amount,
            ),
      );

      pastTwelveMonthsWithExternalDonations.add(element);
    }

    return pastTwelveMonthsWithExternalDonations;
  }

  /// Adds missing months to the list of past twelve months
  /// and sorts them by creation date
  List<SummaryItem> _checkForMissingMonths(List<SummaryItem> currentList) {
    final pastTwelveMonths = <SummaryItem>[];
    final dateFormat = DateFormat('yyyy-MM');
    var currentDate = DateTime.now();

    /// Add missing months to the list
    for (var i = 1; i <= 12; i++) {
      final stringMonth = dateFormat.format(currentDate);
      final currentMonth = currentList.firstWhere(
        (x) => x.key == stringMonth,
        orElse: () => const SummaryItem.empty(),
      );
      if (currentMonth.key == stringMonth) {
        pastTwelveMonths.add(currentMonth);
      } else {
        pastTwelveMonths.add(
          const SummaryItem.empty().copyWith(
            key: stringMonth,
          ),
        );
      }
      currentDate = currentDate.subtract(const Duration(days: 30));
    }

    pastTwelveMonths.sort((first, second) => first.key.compareTo(second.key));

    return pastTwelveMonths;
  }

  /// Fetches external donations and sorts them by creation date
  /// in descending order.
  Future<List<ExternalDonation>> _fetchExternalDonations({
    required String fromDate,
    required String tillDate,
  }) async {
    final externalDonations = await givtRepo.fetchExternalDonations(
      fromDate: fromDate,
      tillDate: tillDate,
    );

    externalDonations.sort((first, second) {
      final firstDate = DateTime.parse(first.creationDate);
      final secondDate = DateTime.parse(second.creationDate);
      return secondDate.compareTo(firstDate);
    });

    return externalDonations;
  }
}
