import 'dart:async';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/platform_contribution/domain/models/platform_contribution_organization.dart';
import 'package:givt_app/features/platform_contribution/domain/models/platform_contribution_settings.dart';
import 'package:givt_app/features/platform_contribution/domain/repositories/platform_contribution_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/utils/analytics_helper.dart';

/// Cubit for managing platform contribution state
class PlatformContributionCubit extends CommonCubit<PlatformContributionSettings, PlatformContributionCustom> {
  PlatformContributionCubit({
    required PlatformContributionRepository repository,
  }) : _repository = repository, super(const BaseState.loading());

  final PlatformContributionRepository _repository;
  StreamSubscription<PlatformContributionSettings>? _settingsSubscription;

  Future<void> init() async {
    await _loadSettings();
    _setupSettingsStream();
  }

  Future<void> _loadSettings() async {
    try {
      emitLoading();
      final settings = await _repository.getSettings();
      emitData(settings);
    } catch (e) {
      emitError(e.toString());
    }
  }

  void _setupSettingsStream() {
    _settingsSubscription = _repository.onSettingsChanged().listen(
      (settings) {
        emitData(settings);
      },
      onError: (Object error) {
        emitError(error.toString());
      },
    );
  }

  /// Update organization toggle
  Future<void> updateOrganizationToggle({
    required String organizationId,
    required bool isEnabled,
    required String organizationName,
  }) async {
    try {
      // Log analytics event
      await AnalyticsHelper.logEvent(
        eventName: AnalyticsEventName.platformContributionToggleChanged,
        eventProperties: {
          AnalyticsHelper.organizationNameKey: organizationName,
          AnalyticsHelper.toggleStatusKey: isEnabled ? 'enabled' : 'disabled',
        },
      );
      
      await _repository.updateOrganizationSettings(
        organizationId: organizationId,
        isEnabled: isEnabled,
      );
    } catch (e) {
      emitError(e.toString());
    }
  }

  /// Update organization contribution level
  Future<void> updateOrganizationContributionLevel({
    required String organizationId,
    required PlatformContributionLevel contributionLevel,
    required String organizationName,
  }) async {
    try {
      // Log analytics event
      await AnalyticsHelper.logEvent(
        eventName: AnalyticsEventName.platformContributionLevelChanged,
        eventProperties: {
          AnalyticsHelper.organizationNameKey: organizationName,
          AnalyticsHelper.contributionLevelKey: contributionLevel.name,
        },
      );
      
      await _repository.updateOrganizationSettings(
        organizationId: organizationId,
        isEnabled: true,
        contributionLevel: contributionLevel,
      );
    } catch (e) {
      emitError(e.toString());
    }
  }

  /// Save all changes
  Future<void> saveChanges() async {
    try {
      emitLoading();
      await _repository.saveChanges();
    } catch (e) {
      emitError(e.toString());
    }
  }

  /// Discard all changes
  Future<void> discardChanges() async {
    try {
      emitLoading();
      await _repository.discardChanges();
    } catch (e) {
      emitError(e.toString());
    }
  }

  /// Navigate to settings screen
  void navigateToSettings() {
    emitCustom(const NavigateToSettings());
  }

  /// Show save changes dialog
  void showSaveChangesDialog() {
    emitCustom(const ShowSaveChangesDialog());
  }

  /// Hide save changes dialog
  void hideSaveChangesDialog() {
    emitCustom(const HideSaveChangesDialog());
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    return super.close();
  }
}

/// Custom events for platform contribution
sealed class PlatformContributionCustom {
  const PlatformContributionCustom();
  
  const factory PlatformContributionCustom.navigateToSettings() = NavigateToSettings;
  const factory PlatformContributionCustom.showSaveChangesDialog() = ShowSaveChangesDialog;
  const factory PlatformContributionCustom.hideSaveChangesDialog() = HideSaveChangesDialog;
}

class NavigateToSettings extends PlatformContributionCustom {
  const NavigateToSettings();
}

class ShowSaveChangesDialog extends PlatformContributionCustom {
  const ShowSaveChangesDialog();
}

class HideSaveChangesDialog extends PlatformContributionCustom {
  const HideSaveChangesDialog();
}
