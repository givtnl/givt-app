import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';

part 'impact_groups_state.dart';

class ImpactGroupsCubit extends Cubit<ImpactGroupsState> {
  ImpactGroupsCubit(
    this._impactGroupInviteRepository,
    this._authCubit,
  ) : super(const ImpactGroupsState()) {
    _authCubit.stream.listen((event) async {
      if (event.status == AuthStatus.authenticated) {
        await fetchImpactGroups();
      }
    });
  }
  final ImpactGroupsRepository _impactGroupInviteRepository;
  final AuthCubit _authCubit;
  Future<void> fetchImpactGroups() async {
    emit(state.copyWith(status: ImpactGroupCubitStatus.loading));

    try {
      final impactGroups =
          await _impactGroupInviteRepository.fetchImpactGroups();

      emit(
        state.copyWith(
          status: ImpactGroupCubitStatus.fetched,
          impactGroups: impactGroups,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ImpactGroupCubitStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void checkForInvites() {
    for (var i = 0; i < state.impactGroups.length; i++) {
      if (state.impactGroups[i].status == ImpactGroupStatus.invited) {
        emit(
          state.copyWith(
            status: ImpactGroupCubitStatus.invited,
            invitedGroup: state.impactGroups[i],
          ),
        );
        break;
      }
    }
  }

  Future<void> acceptGroupInvite({
    required String groupId,
  }) async {
    emit(state.copyWith(status: ImpactGroupCubitStatus.loading));
    try {
      await _impactGroupInviteRepository.acceptGroupInvite(
        groupId: groupId,
      );
      await fetchImpactGroups();
    } catch (e) {
      emit(
        state.copyWith(
          status: ImpactGroupCubitStatus.error,
          error: e.toString(),
        ),
      );
    }
  }
}
