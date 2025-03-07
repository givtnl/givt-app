sealed class StageScreenCustom {
  const StageScreenCustom();

  const factory StageScreenCustom.showCaptainAiPopup() = CaptainAiPopup;

  const factory StageScreenCustom.microphonePermissionsDialog() =
      OpenMicrophonePermissionsDialog;
}

class CaptainAiPopup extends StageScreenCustom {
  const CaptainAiPopup();
}

class OpenMicrophonePermissionsDialog extends StageScreenCustom {
  const OpenMicrophonePermissionsDialog();
}
