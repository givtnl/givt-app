import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class FamilyLoginCubit extends CommonCubit<bool, dynamic> {
  FamilyLoginCubit(
      // this._resetPasswordRepository,
      )
      : super(const BaseState.initial());

  // final ResetPasswordRepository _resetPasswordRepository;

  void init() {
    emitInitial();
  }

  Future<void> login(String email, String password) async {
    emitLoading();
    // try {
    //   // await _resetPasswordRepository.resetPassword(email);
    //   emitSuccess(true);
    // } catch (e) {
    //   emitFailure(e);
    // }
  }
}
