import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/children/details/models/profile_ext.dart';
import 'package:givt_app/features/children/details/repositories/child_details_repository.dart';
import 'package:givt_app/features/children/edit_child/repositories/edit_child_repository.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/utils/analytics_helper.dart';

part 'child_details_state.dart';

class ChildDetailsCubit extends Cubit<ChildDetailsState> {
  ChildDetailsCubit(
    this._childDetailsRepository,
    this._editChildRepository,
    this._profile,
  ) : super(const ChildDetailsInitialState());

  final ChildDetailsRepository _childDetailsRepository;
  final EditChildRepository _editChildRepository;
  final Profile _profile;
  ProfileExt? _profileExt;

  Future<void> fetchChildDetails() async {
    emit(const ChildDetailsFetchingState());
    try {
      _profileExt = await _childDetailsRepository.fetchChildDetails(
        _profile,
      );
      emit(
        ChildDetailsFetchedState(
          profileDetails: _profileExt!,
        ),
      );
    } catch (error, stackTrace) {
      await LoggingInfo.instance
          .error(error.toString(), methodName: stackTrace.toString());
      emit(ChildDetailsErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> updateAllowance(int allowance) async {
    await _logConfirmUpdateAllowanceEvent(allowance);

    try {
      await _editChildRepository.editChildAllowance(
        _profile.id,
        allowance,
      );
      emit(ChildEditGivingAllowanceSuccessState(allowance: allowance));
      //retrieve updated profile after changing the allowance
      unawaited(fetchChildDetails());
    } catch (e, s) {
      await _handleEditAllowanceApiError(e, s);
    }
  }

  Future<void> _handleEditAllowanceApiError(Object e, StackTrace s) async {
    await LoggingInfo.instance.error(e.toString(), methodName: s.toString());
    emit(
      ChildDetailsErrorState(errorMessage: e.toString()),
    );
  }

  Future<void> _logConfirmUpdateAllowanceEvent(int allowance) async {
    await AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.childEditMonthlyAllowanceSaveClicked,
      eventProperties: {
        'child_name': _profile.firstName,
        'new_giving_allowance': allowance,
        'old_giving_allowance': _profileExt?.givingAllowance.amount,
      },
    );
  }
}
