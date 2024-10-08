import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/add_member/repository/add_member_repository.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/utils/analytics_helper.dart';

part 'add_member_state.dart';

class AddMemberCubit extends Cubit<AddMemberState> {
  AddMemberCubit(
    this._addMemberRepository,
  ) : super(const AddMemberState());

  final AddMemberRepository _addMemberRepository;

  Future<void> createMember() async {
    emit(state.copyWith(status: AddMemberStateStatus.loading));
    LoggingInfo.instance.info(
      'Create member',
      methodName: 'createMember',
    );
    final members = state.members;
    final memberNames = members.map((member) => member.firstName).toList();
    final memberAges = members.map((member) => member.age).toList();

    emit(state.copyWith(status: AddMemberStateStatus.loading));

    try {
      await _addMemberRepository.addMembers(members, isRGA: false);

      emit(state.copyWith(status: AddMemberStateStatus.success));
      unawaited(
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.memberCreatedSuccesfully,
          eventProperties: {
            'nrOfMembers': members.length,
            'memberNames': memberNames,
            'memberAges': memberAges,
          },
        ),
      );
    } catch (error) {
      LoggingInfo.instance.error(error.toString());

      if (error is GivtServerFailure &&
          error.type == FailureType.TOPUP_NOT_SUCCESSFUL) {
        unawaited(
          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.topupFailed,
          ),
        );
      } else {
        unawaited(
          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.failedToCreateMember,
          ),
        );
        emit(
          state.copyWith(
            status: AddMemberStateStatus.error,
            error: error.toString(),
          ),
        );
      }
    }
  }

  void addAllMembers(List<Member> members) {
    emit(state.copyWith(members: members));
  }
}
