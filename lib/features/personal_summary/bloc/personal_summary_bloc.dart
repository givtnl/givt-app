import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/core/logging/logging_service.dart';
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
            dateTime: DateTime.now().toIso8601String(),
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
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    try {
      final monthlyGivts = await givtRepo.fetchMonthlySummary(
        guid: state.loggedInUserExt.guid,
        fromDate: firstDayOfMonth.toIso8601String(),
        tillDate: now.toIso8601String(),
      );
      emit(state.copyWith(
        status: PersonalSummaryStatus.success,
        monthlyGivts: monthlyGivts,
      ));
    } on GivtServerFailure catch (e) {
      await LoggingInfo.instance.error(e.toString());
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
        current = DateTime(current.year, current.month + 2, 1)
            .subtract(Duration(days: 1));
      }
    }
    if (event.increase == false) {
      if (current.month == 1) {
        current = DateTime(current.year - 1, 12, 31);
      } else {
        current = DateTime(current.year, current.month, 1)
            .subtract(Duration(days: 1));
      }
    }

    final firstDayOfMonth = DateTime(current.year, current.month, 1);
    try {
      final monthlyGivts = await givtRepo.fetchMonthlySummary(
        guid: state.loggedInUserExt.guid,
        fromDate: firstDayOfMonth.toIso8601String(),
        tillDate: current.toIso8601String(),
      );
      emit(state.copyWith(
        status: PersonalSummaryStatus.success,
        dateTime: current.toIso8601String(),
        monthlyGivts: monthlyGivts,
      ));
    } on GivtServerFailure catch (e) {
      await LoggingInfo.instance.error(e.toString());
      emit(
        state.copyWith(
          status: PersonalSummaryStatus.error,
          error: e.body.toString(),
        ),
      );
    }
  }
}
