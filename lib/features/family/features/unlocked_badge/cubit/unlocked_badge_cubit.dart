import 'package:givt_app/features/family/features/unlocked_badge/presentation/models/unlocked_badge_uimodel.dart';
import 'package:givt_app/features/family/features/unlocked_badge/repository/models/features.dart';
import 'package:givt_app/features/family/features/unlocked_badge/repository/models/unlock_badge_feature.dart';
import 'package:givt_app/features/family/features/unlocked_badge/repository/unlocked_badge_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class UnlockedBadgeCubit extends CommonCubit<UnlockedBadgeUIModel, dynamic> {
  UnlockedBadgeCubit(this._unlockedBadgeRepository)
      : super(const BaseState.initial());

  final UnlockedBadgeRepository _unlockedBadgeRepository;

  List<UnlockBadgeFeature> _unlockedFeatures = [];
  late String? featureId;
  late String profileId;

  void init(String featureId, String profileId) {
    _unlockedFeatures = _unlockedBadgeRepository.getUnlockedFeatures(profileId);
    this.featureId = featureId;
    this.profileId = profileId;

    _emitData();

    _unlockedBadgeRepository
        .onFeatureUnlocksChanged()
        .listen((unlockBadgeStream) {
      if (unlockBadgeStream.userId != profileId) {
        return;
      }

      _unlockedFeatures = unlockBadgeStream.unlockBadgeFeatures;
      _emitData();
    });
  }

  void _emitData() {
    final showBadge = shouldShowBadge();

    emit(
      BaseState.data(
        UnlockedBadgeUIModel(
          showBadge: showBadge,
          count: featureId == null
              ? 0
              : _unlockedBadgeRepository.getTotalCount(profileId, featureId!),
        ),
      ),
    );
  }

  bool shouldShowBadge() {
    // Check if this feature or any hierarchically related feature is unlocked
    for (final feature in _unlockedFeatures) {
      if (!feature.isSeen &&
          (feature.id == featureId ||
              isUnseenChildOrDescendantOf(profileId, feature.id, featureId!))) {
        return true;
      }
    }
    return false;
  }

  void markFeatureAsSeen() {
    if (_unlockedBadgeRepository.isFeatureSeen(profileId, featureId)) {
      return;
    }
    if (featureId != null) {
      _unlockedBadgeRepository.markFeatureAsSeen(profileId, featureId!);
    }
  }

  bool isUnseenChildOrDescendantOf(
    String userId,
    String currentFeature,
    String featureToCheckAsPossibleParent,
  ) {
    final children =
        Features.featureHierarchy[featureToCheckAsPossibleParent] ?? [];
    if (children.contains(currentFeature)) {
      return _isParentAndChildUnseen(
        userId,
        featureToCheckAsPossibleParent,
        currentFeature,
      );
    } else {
      for (final child in children) {
        if (isUnseenChildOrDescendantOf(userId, currentFeature, child)) {
          return _isParentAndChildUnseen(
            userId,
            featureToCheckAsPossibleParent,
            currentFeature,
          );
        }
      }
    }
    return false;
  }

  bool _isParentAndChildUnseen(
    String userId,
    String featureToCheckAsPossibleParent,
    String currentFeature,
  ) {
    return !_unlockedBadgeRepository.isFeatureSeen(
          userId,
          featureToCheckAsPossibleParent,
        ) &&
        !_unlockedBadgeRepository.isFeatureSeen(userId, currentFeature);
  }
}
