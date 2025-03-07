import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/features/qr_scanner/widgets/permissions_dialog.dart';
import 'package:givt_app/features/family/features/qr_scanner/widgets/permissions_dialog_ui_model.dart';

class MicrophonePermissionsDialog extends StatelessWidget {
  const MicrophonePermissionsDialog({
    super.key,
    this.onClickClose,
    this.onClickSettings,
    this.hasDialogLayout = true,
  });

  final VoidCallback? onClickClose;
  final VoidCallback? onClickSettings;
  final bool hasDialogLayout;

  @override
  Widget build(BuildContext context) {
    return FamilyAppPermissionDialog(
      hasDialogLayout: hasDialogLayout,
      model: PermissionsUIModel(
        image: SvgPicture.asset(
          'assets/family/images/record_mic_green.svg',
        ),
        title: 'Turn on the microphone',
        body: 'The microphone allows AI to help improve your conversations.',
        isSettings: true,
        onNextTap: () {
          //nothing
        },
      ),
    );
  }
}
