import 'dart:async';

import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/box_origin/usecases/box_origin_usecase.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class BoxOriginCubit extends CommonCubit<dynamic, dynamic>
    with BoxOriginUseCase {
  BoxOriginCubit(this._familyAuthRepository) : super(const BaseState.initial());

  final FamilyAuthRepository _familyAuthRepository;

  void onSkipClicked() {
    _familyAuthRepository.onRegistrationFinished();
  }

  Future<bool> setBoxOrigin(String churchId) async {
    final result = await sendBoxOriginResult(churchId);
    if (result) {
      unawaited(_familyAuthRepository.onRegistrationFinished());
    }
    return result;
  }
}
