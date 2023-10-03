import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/models.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

part 'add_external_donation_state.dart';

class AddExternalDonationCubit extends Cubit<AddExternalDonationState> {
  AddExternalDonationCubit({
    required String dateTime,
    required this.givtRepository,
  }) : super(
          AddExternalDonationState(
            dateTime: dateTime,
          ),
        );

  final GivtRepository givtRepository;

  Future<void> init() async {
    emit(state.copyWith(status: AddExternalDonationStatus.loading));
    try {
      final dateTime = DateTime.parse(state.dateTime);
      final firstDayOfMonth = DateTime(dateTime.year, dateTime.month);
      final externalDonations = await givtRepository.fetchExternalDonations(
        fromDate: firstDayOfMonth.toIso8601String(),
        tillDate: state.dateTime,
      );
      externalDonations.sort((first, second) {
        final firstDate = DateTime.parse(first.creationDate);
        final secondDate = DateTime.parse(second.creationDate);
        return secondDate.compareTo(firstDate);
      });
      emit(
        state.copyWith(
          status: AddExternalDonationStatus.success,
          externalDonations: externalDonations,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: AddExternalDonationStatus.error));
    }
  }

  void addExternalDonation() {
    // todo
  }

  Future<void> removeExternalDonation({
    required int index,
  }) async {
    emit(state.copyWith(status: AddExternalDonationStatus.loading));
    try {
      final toBeRemoved = state.externalDonations[index];

      final isDeleted = await givtRepository.deleteExternalDonation(
        toBeRemoved.id,
      );
      if (!isDeleted) {
        emit(state.copyWith(status: AddExternalDonationStatus.error));
        return;
      }
      emit(
        state.copyWith(
          status: AddExternalDonationStatus.success,
          externalDonations: state.externalDonations
            ..removeWhere((element) => element.id == toBeRemoved.id),
          currentExternalDonation:
              state.currentExternalDonation.id == toBeRemoved.id
                  ? const ExternalDonation.empty()
                  : state.currentExternalDonation,
        ),
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.warning(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: AddExternalDonationStatus.error));
    }
  }

  void updateExternalDonation({
    required int index,
  }) {
    emit(
      state.copyWith(
        currentExternalDonation: state.externalDonations[index],
        isEdit: true,
      ),
    );
  }

  void save() {
    emit(state.copyWith(status: AddExternalDonationStatus.loading));
    try {} catch (e) {
      emit(state.copyWith(status: AddExternalDonationStatus.error));
    }
  }
}
