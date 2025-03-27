import 'package:givt_app/features/family/features/unlocked_badge/repository/models/unlock_badge_feature.dart';

class UnlockBadgeStream {
  UnlockBadgeStream({required this.userId, required this.unlockBadgeFeatures});
  
  String userId;
  List<UnlockBadgeFeature> unlockBadgeFeatures;
}
