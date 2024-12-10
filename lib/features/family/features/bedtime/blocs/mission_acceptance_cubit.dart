import 'package:collection/collection.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/models/mission_acceptance_custom.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/models/mission_acceptance_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_bar_uimodel.dart';
import 'package:givt_app/features/impact_groups_legacy_logic/repo/impact_groups_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/widgets/extensions/string_extensions.dart';

class MissionAcceptanceCubit
    extends CommonCubit<MissionAcceptanceUIModel, MissionAcceptanceCustom> {
  MissionAcceptanceCubit() : super(const BaseState.initial());

  final ReflectAndShareRepository _reflectAndShareRepository =
      getIt<ReflectAndShareRepository>();
  final ImpactGroupsRepository _impactGroupsRepository =
      getIt<ImpactGroupsRepository>();

  Future<void> init() async {
    String? name;
    var profiles = <GameProfile>[];
    try {
      final groups =
          await _impactGroupsRepository.getImpactGroups(fetchWhenEmpty: true);
      final familyGroup = groups.firstWhereOrNull(
        (element) => element.isFamilyGroup,
      );
      name = familyGroup?.name;
      profiles = await _reflectAndShareRepository.getFamilyProfiles();
      if (true == name?.isNullOrEmpty()) {
        name =
            profiles.firstWhereOrNull((profile) => profile.isAdult)?.lastName;
      }
    } catch (e, s) {
      // fallback is not showing the family name
    }
    emitData(MissionAcceptanceUIModel(
      avatarBarUIModel: AvatarBarUIModel(
        avatarUIModels:
            profiles.map((profile) => profile.toAvatarUIModel()).toList(),
      ),
      familyName: name ?? '',
    ));
  }
}
