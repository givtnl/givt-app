import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/children/details/models/profile_ext.dart';
import 'package:givt_app/features/children/details/repositories/child_details_repository.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';

part 'child_details_state.dart';

class ChildDetailsCubit extends Cubit<ChildDetailsState> {
  ChildDetailsCubit(this._childDetailsRepository)
      : super(const ChildDetailsInitialState());

  final ChildDetailsRepository _childDetailsRepository;

  Future<void> fetchChildDetails(Profile profile) async {
    emit(const ChildDetailsFetchingState());
    try {
      final response = await _childDetailsRepository.fetchChildDetails(profile);
      emit(
        ChildDetailsFetchedState(
          profileDetails: response,
        ),
      );
    } on GivtServerFailure catch (error) {
      await LoggingInfo.instance.error(error.toString());

      emit(ChildDetailsErrorState(errorMessage: error.toString()));
    }
  }
}
