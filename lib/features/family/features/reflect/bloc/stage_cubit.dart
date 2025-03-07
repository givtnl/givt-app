import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/stage_screen_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/stage_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

class StageCubit extends CommonCubit<StageUIModel, StageScreenCustom> {
  StageCubit(this._reflectAndShareRepository)
      : super(
          BaseState.data(
            StageUIModel(
              isAITurnedOn: _reflectAndShareRepository.isAITurnedOn(),
              showAIFeatures: _reflectAndShareRepository.isAiAllowed(),
            ),
          ),
        );

  final ReflectAndShareRepository _reflectAndShareRepository;
  bool _checkForMicPermissionOnResume = false;

  void init() {
    Future.delayed(Duration.zero).then((value) {
      emitCustom(const StageScreenCustom.showCaptainAiPopup());
    });
  }

  void _emitData() {
    emit(
      BaseState.data(
        StageUIModel(
          isAITurnedOn: _reflectAndShareRepository.isAITurnedOn(),
          showAIFeatures: _reflectAndShareRepository.isAiAllowed(),
        ),
      ),
    );
  }

  void onAIEnabledChanged({required bool isEnabled}) =>
      _setAIFeature(isEnabled);

  void _setAIFeature(bool isEnabled) {
    _reflectAndShareRepository.setAIEnabled(value: isEnabled);
    _emitData();
  }

  Future<void> tryToTurnOnCaptainAI() async {
    await _requestMicPermission() ? _enableAI() : _showMicPermissionPopup();
  }

  void _showMicPermissionPopup() {
    emitCustom(const StageScreenCustom.microphonePermissionsDialog());
  }

  void _enableAI() => _setAIFeature(true);

  void maybeLaterCaptainAi() => _disableAI();

  void onMicrophonePermissionDeclined() => _disableAI();

  void _disableAI() => _setAIFeature(false);

  void onMicrophonePermissionSettingsClicked() {
    _checkForMicPermissionOnResume = true;
  }

  Future<void> onResume() async {
    if (_checkForMicPermissionOnResume) {
      _checkForMicPermissionOnResume = false;
      await tryToTurnOnCaptainAI();
    }
  }

  Future<bool> _requestMicPermission() async =>
      Permission.microphone.request().isGranted;

  Future<bool> _hasMicPermission() async =>
      await Permission.microphone.status == PermissionStatus.granted;
}
