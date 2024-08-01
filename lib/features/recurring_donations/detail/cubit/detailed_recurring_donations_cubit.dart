import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/recurring_donations/detail/models/recurring_donation_detail.dart';
import 'package:givt_app/features/recurring_donations/detail/repository/detail_recurring_donation_repository.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';

part 'detailed_recurring_donations_state.dart';

class DetailedRecurringDonationsCubit
    extends Cubit<DetailedRecurringDonationsState> {
  DetailedRecurringDonationsCubit(this._recurringDonationsRepository)
      : super(DetailedRecurringDonationsInitial());
  final DetailRecurringDonationsRepository _recurringDonationsRepository;

  Future<void> fetchRecurringInstances(RecurringDonation selected) async {
    emit(DetailedRecurringDonationsLoading());
    try {
      final response = await _recurringDonationsRepository
          .fetchRecurringInstances(selected.id);
      if (response.isEmpty) {
        emit(DetailedRecurringDonationsEmpty());
        return;
      }
      response.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      emit(DetailedInstancesFetched(instances: response));
    } catch (error) {
      LoggingInfo.instance.error(
        error.toString(),
        methodName: StackTrace.current.toString(),
      );
      emit(DetailedRecurringDonationsError(error: error.toString()));
    }
  }
}
