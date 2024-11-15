import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/models/mission_acceptance_custom.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/models/mission_acceptance_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_bar_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class MissionAcceptanceCubit
    extends CommonCubit<MissionAcceptanceUIModel, MissionAcceptanceCustom> {
  MissionAcceptanceCubit() : super(const BaseState.initial());

  final ReflectAndShareRepository _reflectAndShareRepository =
      getIt<ReflectAndShareRepository>();

  Future<void> init() async {
    final profiles = await _reflectAndShareRepository.getFamilyProfiles();
    emitData(MissionAcceptanceUIModel(
      avatarBarUIModel: AvatarBarUIModel(
        avatarUIModels:
            profiles.map((profile) => profile.toAvatarUIModel()).toList(),
      ),
      familyName: profiles.firstWhere((profile) => profile.isAdult).lastName!,
    ));
  }
}
