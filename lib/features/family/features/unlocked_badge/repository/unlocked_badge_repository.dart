import 'dart:async';

import 'package:givt_app/features/family/features/unlocked_badge/repository/models/features.dart';
import 'package:givt_app/features/family/features/unlocked_badge/repository/models/unlock_badge_feature.dart';
import 'package:givt_app/features/family/features/unlocked_badge/repository/models/unlock_badge_stream.dart';

abstract class UnlockedBadgeRepository {
  Stream<UnlockBadgeStream> onFeatureUnlocksChanged();
  List<UnlockBadgeFeature> getUnlockedFeatures(String userId);
  Future<void> markFeatureAsSeen(String userId, String featureId);
  bool isFeatureSeen(String userId, String? featureId);
}

class UnlockedBadgeRepositoryImpl extends UnlockedBadgeRepository {
// Implementation in ProfilesRepositoryImpl
  final StreamController<UnlockBadgeStream> _featureUnlocksController =
      StreamController<UnlockBadgeStream>.broadcast();

  // Map to store unlocked features per user
  final Map<String, List<UnlockBadgeFeature>> _userUnlockedFeatures = {};

  // Default features for new users
  List<UnlockBadgeFeature> _getDefaultFeatures() => [
        const UnlockBadgeFeature(
          id: Features.avatarCustomBody,
          isSeen: false,
        ),
        const UnlockBadgeFeature(
          id: Features.avatarCustomHair,
          isSeen: false,
        ),
        const UnlockBadgeFeature(
          id: Features.avatarCustomMask,
          isSeen: false,
        ),
        const UnlockBadgeFeature(
          id: Features.avatarCustomSuit,
          isSeen: false,
        ),
      ];

  // Get or initialize features for a user
  List<UnlockBadgeFeature> _getUserFeatures(String userId) {
    if (!_userUnlockedFeatures.containsKey(userId)) {
      _userUnlockedFeatures[userId] = _getDefaultFeatures();
    }
    return _userUnlockedFeatures[userId]!;
  }

  @override
  Stream<UnlockBadgeStream> onFeatureUnlocksChanged() =>
      _featureUnlocksController.stream;

  @override
  List<UnlockBadgeFeature> getUnlockedFeatures(String userId) =>
      _getUserFeatures(userId);

  @override
  Future<void> markFeatureAsSeen(String userId, String featureId) async {
    final userFeatures = _getUserFeatures(userId);

    final updatedFeatures = userFeatures.map((feature) {
      if (feature.id == featureId) {
        return UnlockBadgeFeature(
          id: feature.id,
          isSeen: true,
        );
      }
      return feature;
    }).toList();

    _userUnlockedFeatures[userId] = updatedFeatures;
    _featureUnlocksController.add(
      UnlockBadgeStream(
        userId: userId,
        unlockBadgeFeatures: updatedFeatures,
      ),
    );
  }

  @override
  bool isFeatureSeen(String userId, String? featureId) {
    final userFeatures = _getUserFeatures(userId);

    if (featureId == null ||
        !userFeatures.any((feature) => feature.id == featureId)) {
      return false;
    }

    return userFeatures.firstWhere((feature) => feature.id == featureId).isSeen;
  }
}
