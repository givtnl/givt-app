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
      final currentDate = DateTime.parse(state.dateTime);

      /// DateTime used for querying external donations
      final firstDayOfMonth = DateTime(currentDate.year, currentDate.month);
      final untilDate = DateTime(currentDate.year, currentDate.month + 1);

      final externalDonations = await givtRepository.fetchExternalDonations(
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
          status: AddExternalDonationStatus.success,
          externalDonations: externalDonations,
        ),
      );
    } catch (e, stackTrace) {
      LoggingInfo.instance.warning(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: AddExternalDonationStatus.error));
    }
  }

  Future<void> addExternalDonation(ExternalDonation externalDonation) async {
    emit(state.copyWith(status: AddExternalDonationStatus.loading));
    try {
      final dateTime = DateTime.parse(state.dateTime);

      final toBeAdded = state.currentExternalDonation.copyWith(
        creationDate: dateTime.toIso8601String(),
        description: externalDonation.description,
        amount: externalDonation.amount,
        frequency: externalDonation.frequency,
        taxDeductible: externalDonation.taxDeductible,
      );

      if (state.isEdit) {
        final isUpdated = await givtRepository.updateExternalDonation(
          id: state.currentExternalDonation.id,
          body: toBeAdded.toJson(),
        );

        if (!isUpdated) {
          emit(state.copyWith(status: AddExternalDonationStatus.error));
          return;
        }

        final indexOfCurrent = state.externalDonations.indexWhere(
          (element) => element.id == state.currentExternalDonation.id,
        );

        emit(
          state.copyWith(
            status: AddExternalDonationStatus.success,
            externalDonations: state.externalDonations
              ..removeWhere(
                (element) => element.id == state.currentExternalDonation.id,
              )
              ..insert(indexOfCurrent, toBeAdded),
            currentExternalDonation: const ExternalDonation.empty(),
            isEdit: false,
          ),
        );
        return;
      }

      final isAdded = await givtRepository.addExternalDonation(
        body: toBeAdded.toJson(),
      );

      if (!isAdded) {
        emit(state.copyWith(status: AddExternalDonationStatus.error));
        return;
      }

      emit(
        state.copyWith(
          status: AddExternalDonationStatus.success,
          externalDonations: state.externalDonations..insert(0, toBeAdded),
          currentExternalDonation: const ExternalDonation.empty(),
        ),
      );
    } catch (e, stackTrace) {
      LoggingInfo.instance.warning(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: AddExternalDonationStatus.error));
    }
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
      LoggingInfo.instance.warning(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: AddExternalDonationStatus.error));
    }
  }

  void updateCurrentExternalDonation({
    required int index,
  }) {
    emit(
      state.copyWith(
        currentExternalDonation: state.externalDonations[index],
        isEdit: true,
      ),
    );
  }
}
