import 'package:givt_app/features/family/features/reflect/domain/models/game_stats.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/mission_stats.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_uimodel.dart';

class FamilyHomeScreenUIModel {
  const FamilyHomeScreenUIModel({
    required this.avatars,
    this.familyGroupName,
    this.gameStats,
    this.missionStats,
  });

  final List<AvatarUIModel> avatars;
  final String? familyGroupName;
  final GameStats? gameStats;
  final MissionStats? missionStats;
}
