import 'package:givt_app/features/family/features/reflect/presentation/models/recommendations_ui_model.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

class GratefulUIModel {
  const GratefulUIModel({
    required this.avatarBarUIModel,
    required this.recommendationsUIModel,
  });

  final AvatarBarUIModel avatarBarUIModel;
  final RecommendationsUIModel recommendationsUIModel;
}
