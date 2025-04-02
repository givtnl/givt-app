import 'dart:async';

import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
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
  Future<void> markAllFeaturesAsSeenForUser(String userId);
  int getTotalCount(String userId, String featureId);

  bool hasAnyProfileAnyUnseenBadges();
}

class UnlockedBadgeRepositoryImpl extends UnlockedBadgeRepository {
  UnlockedBadgeRepositoryImpl(this._profilesRepository, this._prefs) {
    _init();
  }
// Implementation in ProfilesRepositoryImpl
  final StreamController<UnlockBadgeStream> _featureUnlocksController =
      StreamController<UnlockBadgeStream>.broadcast();

  // Map to store unlocked features per user
  final Map<String, List<UnlockBadgeFeature>> _userUnlockedFeatures = {};

  final SharedPreferences _prefs;
  final ProfilesRepository _profilesRepository;

  static const _prefsStorageKeyPrefix = 'unlocked_feature_prefix_';

  void _init() {
    _profilesRepository.onProfilesChanged().listen((profiles) {
      for (final profile in profiles) {
        final oldFeatures = _userUnlockedFeatures[profile.id];
        final features = <UnlockBadgeFeature>[];
        for (final unlockedFeature in profile.unlocks) {
          if (Features.isItemFeature(unlockedFeature) &&
              (oldFeatures == null ||
                  oldFeatures
                          .where(
                            (oldFeature) => oldFeature.id == unlockedFeature,
                          )
                          .isEmpty ==
                      true)) {
            if (!isFeatureSeen(profile.id, unlockedFeature)) {
              features.add(
                UnlockBadgeFeature(
                  id: unlockedFeature,
                  isSeen: isFeatureSeen(profile.id, unlockedFeature),
                  count: 1,
                ),
              );
            }
          }
        }
        _userUnlockedFeatures[profile.id] = [...?oldFeatures, ...features];
        _featureUnlocksController.add(
          UnlockBadgeStream(
            userId: profile.id,
            unlockBadgeFeatures: _userUnlockedFeatures[profile.id] ?? [],
          ),
        );
      }
    });
  }

  // Get or initialize features for a user
  List<UnlockBadgeFeature> _getUserFeatures(String userId) {
    if (!_userUnlockedFeatures.containsKey(userId)) {
      _userUnlockedFeatures[userId] = [];
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
      if (feature.id.contains(featureId)) {
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

    userFeatures
        .where((feature) => feature.id.contains(featureId))
        .forEach((feature) {
      unawaited(_prefs.setBool(_getKey(userId, feature.id), true));
    });
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

    userFeatures
        .where((feature) => feature.id.contains(featureId))
        .forEach((feature) {
      unawaited(_prefs.remove(_getKey(userId, featureId)));
    });
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
        !userFeatures.any((feature) => feature.id.contains(featureId))) {
      return false;
    }

    var hasAnyNotBeenSeen = false;
    for (final feature in userFeatures) {
      if (feature.id.contains(featureId) && !feature.isSeen) {
        hasAnyNotBeenSeen = true;
        break;
      }
    }

    return !hasAnyNotBeenSeen;
  }

  @override
  Future<void> markAllFeaturesAsSeenForUser(String userId) async {
    final userFeatures = _getUserFeatures(userId);

    final updatedFeatures = userFeatures.map((feature) {
      unawaited(_prefs.setBool(_getKey(userId, feature.id), true));
      return feature.copyWith(isSeen: true);
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
  int getTotalCount(String userId, String featureId) {
    final userFeatures = _getUserFeatures(userId);

    return userFeatures
        .where((feature) => feature.id.contains(featureId) && !feature.isSeen)
        .fold(0, (sum, feature) => sum + feature.count);
  }

  @override
  bool hasAnyProfileAnyUnseenBadges() {
    for (final userId in _userUnlockedFeatures.keys) {
      final userFeatures = _getUserFeatures(userId);
      if (userFeatures.any((feature) => !feature.isSeen)) {
        return true;
      }
    }
    return false;
  }
}
