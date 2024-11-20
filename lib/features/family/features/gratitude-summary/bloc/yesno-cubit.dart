import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/gratitude-summary/domain/repositories/parent_summary_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class YesNoCubit extends CommonCubit<dynamic, bool> {
  YesNoCubit() : super(const BaseState.initial());

  final ParentSummaryRepository _summaryRepository =
      getIt<ParentSummaryRepository>();
  final FamilyAuthRepository _familyAuthRepository =
      getIt<FamilyAuthRepository>();

  late final String childGuid;

  void init(String childGuid) {
    this.childGuid = childGuid;
  }

  void onClickedNo() {
    saveDecision(yes: false);
  }

  void saveDecision({required bool yes}) {
    try {
      _summaryRepository.sendYesNoPutKidToBed(
        childGuid: childGuid,
        parentGuid: _familyAuthRepository.getCurrentUser()!.guid,
        yes: yes,
      );
    } catch (e) {
      // it's okay if we fail, the fall-back is that both parents get winddown-time push notifications
    }
    emitCustom(yes);
  }

  void onClickedYes() {
    saveDecision(yes: true);
  }
}
