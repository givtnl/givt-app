import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/add_member/repository/add_member_repository.dart';
import 'package:givt_app/features/children/cached_members/repositories/cached_members_repository.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/utils/analytics_helper.dart';

part 'add_member_state.dart';

class AddMemberCubit extends Cubit<AddMemberState> {
  AddMemberCubit(
    this._addMemberRepository,
    this._cachedMembersRepository,
  ) : super(const AddMemberState());

  final AddMemberRepository _addMemberRepository;
  final CachedMembersRepository _cachedMembersRepository;

  void decreaseNrOfForms() {
    emit(state.copyWith(
      nrOfForms: max(1, state.nrOfForms - 1),
      members: [],
    ));
  }

  void increaseNrOfForms() {
    emit(state.copyWith(
      nrOfForms: state.nrOfForms + 1,
    ));
  }

  void validateForms() {
    emit(
      state.copyWith(
        members: state.members,
        status: AddMemberStateStatus.input,
        formStatus: AddMemberFormStatus.validate,
      ),
    );
  }

  void resetFormStatus() {
    emit(
      state.copyWith(
        members: state.members,
        status: AddMemberStateStatus.input,
        formStatus: AddMemberFormStatus.initial,
      ),
    );
  }

  void allFormsFilled() {
    if (state.hasChildren) {
      emit(
        state.copyWith(
          members: state.members,
          formStatus: AddMemberFormStatus.success,
          status: AddMemberStateStatus.vpc,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        members: state.members,
        formStatus: AddMemberFormStatus.success,
        status: AddMemberStateStatus.continueWithoutVPC,
      ),
    );
  }

  void dismissedVPC() {
    emit(
      state.copyWith(
        members: state.members,
        status: AddMemberStateStatus.input,
      ),
    );
  }

  void rememberProfile({
    required Member member,
    required String invisibleSecondKey,
  }) {
    final invisibleSecondMemberIndex =
        state.members.indexWhere((p) => p.key == invisibleSecondKey);
    final existingChildIndex =
        state.members.indexWhere((p) => p.key == member.key);

    if (existingChildIndex != -1) {
      // Child with the same key exists, replace it
      final List<Member> updatedChildren = List.from(state.members);
      updatedChildren[existingChildIndex] = member;

      if (invisibleSecondMemberIndex != -1) {
        // Both invisible second member and existing child exist, remove invisible second member
        updatedChildren.removeAt(invisibleSecondMemberIndex);
      }

      emit(
        state.copyWith(
          members: updatedChildren,
          status: AddMemberStateStatus.input,
          formStatus: AddMemberFormStatus.initial,
        ),
      );
    } else {
      if (invisibleSecondMemberIndex != -1) {
        // Invisible second member exists, remove it
        final List<Member> updatedChildren = List.from(state.members);
        updatedChildren.removeAt(invisibleSecondMemberIndex);

        emit(
          state.copyWith(
            members: updatedChildren,
            status: AddMemberStateStatus.input,
            formStatus: AddMemberFormStatus.initial,
          ),
        );
      }

      // Add the new member
      emit(
        state.copyWith(
          members: List.from(state.members)..add(member),
          status: AddMemberStateStatus.input,
          formStatus: AddMemberFormStatus.initial,
        ),
      );
    }
  }

  Future<void> createMember() async {
    final members = state.members;
    final memberNames = members.map((member) => member.firstName).toList();

    emit(state.copyWith(status: AddMemberStateStatus.loading));
    try {
      final membersAddedSuccessfully =
          await _addMemberRepository.addMembers(members);

      if (membersAddedSuccessfully) {
        emit(state.copyWith(status: AddMemberStateStatus.success));

        unawaited(
          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.memberCreatedSuccesfully,
            eventProperties: {
              'nrOfMembers': members.length,
              'memberNames': memberNames,
            },
          ),
        );
      }
    } catch (error) {
      await LoggingInfo.instance.error(error.toString());

      if (error is GivtServerFailure &&
          error.type == FailureType.VPC_NOT_SUCCESSFUL) {
        await _saveMembersToCache();

        unawaited(
          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.failedToCreateMember,
          ),
        );
      }
      if (error is GivtServerFailure &&
          error.type == FailureType.ALLOWANCE_NOT_SUCCESSFUL) {
        emit(state.copyWith(status: AddMemberStateStatus.successNoAllowances));

        unawaited(
          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.allowanceNotSuccessful,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AddMemberStateStatus.error,
            error: error.toString(),
          ),
        );
      }
    }
  }

  Future<void> _saveMembersToCache() async {
    await _cachedMembersRepository.saveToCache(state.members);
    emit(state.copyWith(status: AddMemberStateStatus.successCached));
    final memberNames =
        state.members.map((member) => member.firstName).toList();

    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.cacheMembersDueToNoFunds,
        eventProperties: {
          'memberNames': memberNames,
        },
      ),
    );
  }
}
