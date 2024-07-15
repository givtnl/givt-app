import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/features/qr_scanner/widgets/permissions_dialog.dart';
import 'package:givt_app/features/family/features/qr_scanner/widgets/permissions_dialog_ui_model.dart';

class GalleryPermissionsDialog extends StatelessWidget {
  const GalleryPermissionsDialog({this.isSettings = false, super.key});
  final bool isSettings;
  @override
  Widget build(BuildContext context) {
    return FamilyAppPermissionDialog(
      model: PermissionsUIModel(
        body: isSettings
            ? 'To upload a picture we need to access your gallery. Go to Settings to allow that.'
            : 'To upload a picture we need to access your gallery. Press OK in the next screen to allow that.',
        isSettings: isSettings,
        title: 'Can we open your photo gallery?',
        image: SvgPicture.asset(
          'assets/images/image_duotone.svg',
        ),
        onNextTap: () {
          // usecase should not happen in the current flow
        },
      ),
    );
  }
}
