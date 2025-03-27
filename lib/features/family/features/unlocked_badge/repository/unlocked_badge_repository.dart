import 'dart:async';

import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/features/unlocked_badge/repository/models/features.dart';
import 'package:givt_app/features/family/features/unlocked_badge/repository/models/unlock_badge_feature.dart';
import 'package:givt_app/features/family/features/unlocked_badge/repository/models/unlock_badge_stream.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UnlockedBadgeRepository {
  Stream<UnlockBadgeStream> onFeatureUnlocksChanged();
  List<UnlockBadgeFeature> getUnlockedFeatures(String userId);
  Future<void> markFeatureAsSeen(String userId, String featureId);
  Future<void> markFeatureAsUnseen(String userId, String featureId);
  bool isFeatureSeen(String userId, String? featureId);
}

class UnlockedBadgeRepositoryImpl extends UnlockedBadgeRepository {
// Implementation in ProfilesRepositoryImpl
  final StreamController<UnlockBadgeStream> _featureUnlocksController =
      StreamController<UnlockBadgeStream>.broadcast();

  // Map to store unlocked features per user
  final Map<String, List<UnlockBadgeFeature>> _userUnlockedFeatures = {};

  final SharedPreferences _prefs = getIt<SharedPreferences>();

  static const _prefsStorageKeyPrefix = 'unlocked_feature_prefix_';

  // Default features for new users
  List<UnlockBadgeFeature> _getDefaultFeatures(String userId) => [
        UnlockBadgeFeature(
          id: Features.avatarCustomBody,
          isSeen: _prefs.containsKey(
            _getKey(userId, Features.avatarCustomBody),
          ),
          count: 12,
        ),
        UnlockBadgeFeature(
          id: Features.avatarCustomHair,
          isSeen: _prefs.containsKey(
            _getKey(userId, Features.avatarCustomHair),
          ),
          count: 3,
        ),
        UnlockBadgeFeature(
          id: Features.avatarCustomMask,
          isSeen: _prefs.containsKey(
            _getKey(userId, Features.avatarCustomMask),
          ),
          count: 3,
        ),
        UnlockBadgeFeature(
          id: Features.avatarCustomSuit,
          isSeen: _prefs.containsKey(
            _getKey(userId, Features.avatarCustomSuit),
          ),
          count: 2,
        ),
      ];

  // Get or initialize features for a user
  List<UnlockBadgeFeature> _getUserFeatures(String userId) {
    if (!_userUnlockedFeatures.containsKey(userId)) {
      _userUnlockedFeatures[userId] = _getDefaultFeatures(userId);
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

    unawaited(_prefs.setBool(_getKey(userId, featureId), true));
  }

  @override
  Future<void> markFeatureAsUnseen(String userId, String featureId) async {
    final userFeatures = _getUserFeatures(userId);

    final updatedFeatures = userFeatures.map((feature) {
      if (feature.id == featureId) {
        return UnlockBadgeFeature(
          id: feature.id,
          isSeen: false,
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

    unawaited(_prefs.remove(_getKey(userId, featureId)));
  }

  String _getKey(String userId, String? featureId) =>
      '$_prefsStorageKeyPrefix$featureId$userId';

  @override
  bool isFeatureSeen(String userId, String? featureId) {
    final userFeatures = _getUserFeatures(userId);

    if (_prefs.containsKey(_getKey(userId, featureId))) {
      return true;
    }

    if (featureId == null ||
        !userFeatures.any((feature) => feature.id == featureId)) {
      return false;
    }

    return userFeatures.firstWhere((feature) => feature.id == featureId).isSeen;
  }
}
