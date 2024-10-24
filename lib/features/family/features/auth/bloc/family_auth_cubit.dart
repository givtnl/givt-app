import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/auth/presentation/models/family_auth_state.dart';
import 'package:givt_app/shared/models/models.dart';

class FamilyAuthCubit extends Cubit<FamilyAuthState> {
  FamilyAuthCubit(this._authRepository)
      : super(const FamilyAuthState.unauthenticated()) {
    _init();
  }

  final FamilyAuthRepository _authRepository;
  StreamSubscription<UserExt?>? _authSubscription;

  Future<void> _init() async {
    _authSubscription = _authRepository
        .authenticatedUserStream()
        .listen(_handleAuthenticationUpdate);
  }

  void _handleAuthenticationUpdate(UserExt? userExt) {
    if (userExt != null) {
      emit(FamilyAuthState.authenticated(userExt));
    } else {
      emit(const FamilyAuthState.unauthenticated());
    }
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    await super.close();
  }
}
