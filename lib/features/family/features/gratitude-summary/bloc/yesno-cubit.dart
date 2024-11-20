import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/gratitude-summary/domain/repositories/summary_repository.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class YesNoCubit extends CommonCubit<dynamic, bool> {
  YesNoCubit(super.initialState);

  final SummaryRepository _summaryRepository = getIt<SummaryRepository>();
  final FamilyAuthRepository _familyAuthRepository = getIt<FamilyAuthRepository>();

  late final String childGuid;

  void init(String childGuid) {
    this.childGuid = childGuid;
  }

  Future<void> onClickedNo() async {
    await saveDecision(yes: false);
  }

  Future<void> saveDecision({required bool yes}) async {
    try {
    await _summaryRepository.sendYesNoPutKidToBed(
      childGuid: childGuid,
      parentGuid: _familyAuthRepository.getCurrentUser()!.guid,
        yes: yes,
      );
    } catch (e) {
      // it's okay if we fail, the fall-back is that both parents get winddown-time push notifications
    }
    emitCustom(yes);
  }

  Future<void> onClickedYes() async {
    await saveDecision(yes: true);
  }
}