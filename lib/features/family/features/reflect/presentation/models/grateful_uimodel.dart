import 'package:givt_app/features/family/features/reflect/presentation/models/recommendations_ui_model.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_bar_uimodel.dart';

class GratefulUIModel {
  const GratefulUIModel({
    required this.avatarBarUIModel,
    required this.recommendationsUIModel,
  });

  final AvatarBarUIModel avatarBarUIModel;
  final RecommendationsUIModel recommendationsUIModel;
}
