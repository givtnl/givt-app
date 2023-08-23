// ignore_for_file: cascade_invocations

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/features/children/overview/models/wallet.dart';
import 'package:givt_app/features/children/overview/repositories/children_overview_repository.dart';

part 'children_overview_state.dart';

class ChildrenOverviewCubit extends Cubit<ChildrenOverviewState> {
  ChildrenOverviewCubit(this._childrenOverviewRepository)
      : super(const ChildrenOverviewInitialState());

  final ChildrenOverviewRepository _childrenOverviewRepository;

  Future<void> fetchChildren(String parentGuid) async {
    emit(const ChildrenOverviewLoadingState());

    try {
      final response =
          await _childrenOverviewRepository.fetchChildren(parentGuid);
      emit(ChildrenOverviewUpdatedState(profiles: response));
    } catch (error) {
      final fakeChildren = <Profile>[];

      fakeChildren.add(
        const Profile(
          id: '',
          firstName: 'Pavlo',
          lastName: '',
          nickname: '',
          comment: '',
          wallet: Wallet(balance: 0, total: 42, pending: 0, currency: ''),
          pictureURL: '',
        ),
      );

      fakeChildren.add(
        const Profile(
          id: '',
          firstName: 'Emma',
          lastName: '',
          nickname: '',
          comment: '',
          wallet: Wallet(balance: 0, total: 99, pending: -25, currency: ''),
          pictureURL: '',
        ),
      );

      fakeChildren.add(
        const Profile(
          id: '',
          firstName: 'John',
          lastName: '',
          nickname: '',
          comment: '',
          wallet: Wallet(balance: 0, total: 20, pending: -4, currency: ''),
          pictureURL: '',
        ),
      );

      fakeChildren.add(
        const Profile(
          id: '',
          firstName: 'Pedro',
          lastName: '',
          nickname: '',
          comment: '',
          wallet: Wallet(balance: 0, total: 120, pending: 54, currency: ''),
          pictureURL: '',
        ),
      );

      fakeChildren.add(
        const Profile(
          id: '',
          firstName: 'Bob',
          lastName: '',
          nickname: '',
          comment: '',
          wallet: Wallet(balance: 0, total: 89, pending: 10, currency: ''),
          pictureURL: '',
        ),
      );

      emit(ChildrenOverviewUpdatedState(profiles: fakeChildren));

      // emit(ChildrenOverviewErrorState(errorMessage: error.toString()));
    }
  }
}
