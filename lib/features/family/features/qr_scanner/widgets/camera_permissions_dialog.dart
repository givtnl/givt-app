import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/qr_scanner/cubit/camera_cubit.dart';
import 'package:givt_app/features/family/features/qr_scanner/widgets/permissions_dialog.dart';
import 'package:givt_app/features/family/features/qr_scanner/widgets/permissions_dialog_ui_model.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class CameraPermissionsDialog extends StatelessWidget {
  const CameraPermissionsDialog(
      {required this.cameraCubit, this.isSettings = false, super.key});
  final bool isSettings;
  final CameraCubit cameraCubit;
  @override
  Widget build(BuildContext context) {
    return FamilyAppPermissionDialog(
      model: PermissionsUIModel(
        image: SvgPicture.asset(
          'assets/family/images/camera_dutone.svg',
        ),
        title: 'Can we use the camera?',
        body: isSettings
            ? 'To scan the QR Code we need to turn on the camera. Go to Settings to allow that.'
            : 'To scan the QR Code we need to turn on the camera in the app. Press OK in the next screen to allow that.',
        isSettings: isSettings,
        onNextTap: () {
          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.nextPermissionsDialogClicked,
            eventProperties: {
              'permission': 'camera',
            },
          );
          cameraCubit.grantAccess();
          context.pop();
        },
      ),
    );
  }
}
