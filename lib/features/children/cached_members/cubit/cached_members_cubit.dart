import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/add_member/repository/add_member_repository.dart';
import 'package:givt_app/features/children/cached_members/repositories/cached_members_repository.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/utils/utils.dart';

part 'cached_members_state.dart';

class CachedMembersCubit extends Cubit<CachedMembersState> {
  CachedMembersCubit(
    this._addMemberRepository,
    this._cachedMembersRepository, {
    String familyLeaderName = '',
  }) : super(
          CachedMembersState(
            familyLeader: Member(
              firstName: familyLeaderName,
              type: ProfileType.Parent,
            ),
          ),
        );

  final CachedMembersRepository _cachedMembersRepository;
  final AddMemberRepository _addMemberRepository;

  Future<List<Member>> loadFromCache() async {
    emit(state.copyWith(status: CachedMembersStateStatus.loading));

    final members = await _cachedMembersRepository.loadFromCache();

    emit(
      state.copyWith(
        status: CachedMembersStateStatus.noFundsInitial,
        members: members,
      ),
    );

    return members;
  }

  Future<void> clearCache() async {
    emit(state.copyWith(status: CachedMembersStateStatus.loading));

    try {
      await _cachedMembersRepository.clearCache();
      emit(state.copyWith(status: CachedMembersStateStatus.noFundsInitial));
    } catch (error, stackTrace) {
      LoggingInfo.instance
          .error(error.toString(), methodName: stackTrace.toString());
      emit(state.copyWith(status: CachedMembersStateStatus.error));
    }
  }

  Future<void> tryCreateMembersFromCache(List<Member>? cached) async {
    emit(state.copyWith(status: CachedMembersStateStatus.noFundsRetrying));
    try {
      final members = cached ?? state.members;
      await _addMemberRepository.addMembers(members, isRGA: false);

      emit(state.copyWith(status: CachedMembersStateStatus.noFundsSuccess));
      await clearCache();

      final memberNames = members.map((member) => member.firstName).toList();
      unawaited(
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.memberCreatedSuccesfully,
          eventProperties: {
            'nrOfMembers': members.length,
            'memberNames': memberNames,
          },
        ),
      );
    } catch (error, stackTrace) {
      LoggingInfo.instance
          .error(error.toString(), methodName: stackTrace.toString());
      unawaited(
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.failedToCreateMembersFromCache,
        ),
      );

      emit(
        state.copyWith(
          status: CachedMembersStateStatus.error,
        ),
      );
    }
  }
}
