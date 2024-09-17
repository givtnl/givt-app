import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/qr_scanner/cubit/camera_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPermissionSettingsEuDialog extends StatelessWidget {
  const CameraPermissionSettingsEuDialog({
    required this.cameraCubit,
    required this.onCancel,
    super.key,
  });
  final CameraCubit cameraCubit;
  final VoidCallback onCancel;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        context.l10n.accessDenied,
      ),
      content: const Text(
          'To scan the QR Code we need to turn on the camera. Go to Settings to allow that.'),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            openAppSettings();
            cameraCubit.grantAccess();
            context.pop();
          },
          child: Text('Go to Settings'),
        ),
      ],
    );
  }
}
