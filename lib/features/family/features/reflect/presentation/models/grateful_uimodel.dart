import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/recommendations_ui_model.dart';

class GratefulUIModel {
  const GratefulUIModel({
    required this.avatarBarUIModel,
    required this.recommendationsUIModel,
  });

  final GratefulAvatarBarUIModel avatarBarUIModel;
  final RecommendationsUIModel recommendationsUIModel;
}
