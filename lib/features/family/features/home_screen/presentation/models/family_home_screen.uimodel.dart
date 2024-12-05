import 'package:givt_app/features/family/features/reflect/domain/models/game_stats.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_uimodel.dart';

class FamilyHomeScreenUIModel {
  const FamilyHomeScreenUIModel({
    required this.avatars,
    this.familyGroupName,
    this.gameStats,
    this.showLatestSummaryBtn = false,
  });

  final List<AvatarUIModel> avatars;
  final String? familyGroupName;
  final GameStats? gameStats;
  final bool showLatestSummaryBtn;
}
