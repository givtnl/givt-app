import 'package:bloc/bloc.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/auth/presentation/models/family_auth_state.dart';
import 'package:givt_app/shared/models/models.dart';

class FamilyAuthCubit extends Cubit<FamilyAuthState> {
  FamilyAuthCubit(this._authRepository) : super(const FamilyAuthState.unauthenticated()) {
    _init();
  }

  final FamilyAuthRepository _authRepository;

  Future<void> _init() async {
    _authRepository.authenticatedUserStream().listen(_handleAuthenticationUpdate);
  }

  void _handleAuthenticationUpdate(bool hasSession) {
    if(hasSession) {
     _authRepository.isAuthenticated()
    } else {
      emit(const FamilyAuthState.unauthenticated());
    }
  }

  void _handleUserUpdate(UserExt? userExt) {
    if (userExt != null) {
      emit(FamilyAuthState.authenticated(userExt));
    }
  }

}
