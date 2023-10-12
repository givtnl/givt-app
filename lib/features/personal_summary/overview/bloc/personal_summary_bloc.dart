import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/models.dart';
import 'package:givt_app/shared/models/monthly_summary_item.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/shared/repositories/repositories.dart';

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
      final monthlyGivts = await givtRepo.fetchMonthlySummary(
        guid: state.loggedInUserExt.guid,
        fromDate: firstDayOfMonth.toIso8601String(),
        tillDate: untilDate.toIso8601String(),
      );
      final externalDonations = await givtRepo.fetchExternalDonations(
        fromDate: firstDayOfMonth.toIso8601String(),
        tillDate: untilDate.toIso8601String(),
      );
      externalDonations.sort((first, second) {
        final firstDate = DateTime.parse(first.creationDate);
        final secondDate = DateTime.parse(second.creationDate);
        return secondDate.compareTo(firstDate);
      });
      emit(
        state.copyWith(
          status: PersonalSummaryStatus.success,
          monthlyGivts: monthlyGivts,
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
      final monthlyGivts = await givtRepo.fetchMonthlySummary(
        guid: state.loggedInUserExt.guid,
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
}
