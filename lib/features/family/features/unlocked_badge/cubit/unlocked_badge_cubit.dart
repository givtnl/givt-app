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
  String? featureId;
  String? profileId;

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
        ),
      ),
    );
  }

  bool shouldShowBadge() {
    // Check if this feature or any hierarchically related feature is unlocked
    for (final feature in _unlockedFeatures) {
      if (!feature.isSeen &&
          (feature.id == featureId || feature.isChildOf(featureId))) {
        return true;
      }
    }
    return false;
  }

  void markFeatureAsSeen() {
    if (_unlockedBadgeRepository.isFeatureSeen(profileId!, featureId)) {
      return;
    }
    if (featureId != null) {
      _unlockedBadgeRepository.markFeatureAsSeen(profileId!, featureId!);
    }
  }
}

extension on UnlockBadgeFeature {
  bool isChildOf(String? featureId) {
    for (final childId in Features.featureHierarchy[featureId] ?? []) {
      if (childId == id) {
        return true;
      }

      if (Features.featureHierarchy.containsKey(childId) &&
          Features.featureHierarchy[childId]!.contains(id)) {
        return true;
      }
    }

    return false;
  }
}
