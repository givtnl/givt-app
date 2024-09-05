import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/family/features/qr_scanner/cubit/camera_cubit.dart';
import 'package:givt_app/features/family/features/qr_scanner/widgets/camera_permissions_dialog.dart';
import 'package:givt_app/features/family/features/qr_scanner/widgets/gallery_permissions_dialog.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/utils/utils.dart';

class Day5PictureAttachmentButtons extends StatelessWidget {
  const Day5PictureAttachmentButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GenerosityChallengeCubit>();
    return BlocProvider(
      create: (context) => CameraCubit(),
      child: BlocConsumer<CameraCubit, CameraState>(
        listener: (context, state) {
          if (state.status == CameraStatus.permissionPermanentlyDeclined) {
            showDialog<void>(
              context: context,
              builder: (_) {
                return CameraPermissionsDialog(
                  cameraCubit: context.read<CameraCubit>(),
                  isSettings: true,
                );
              },
            );
          }
          if (state.galleryStatus ==
                  GalleryStatus.permissionPermanentlyDeclined ||
              state.galleryStatus == GalleryStatus.requestPermission) {
            showDialog<void>(
              context: context,
              builder: (_) {
                return const GalleryPermissionsDialog(isSettings: true);
              },
            );
          }
        },
        builder: (context, state) => Column(
          children: [
            const SizedBox(height: 8),
            FunButton(
              onTap: () async {
                final success = await cubit.submitDay5Picture(
                  takenWithCamera: true,
                );
                if (context.mounted && !success) {
                  unawaited(
                    context.read<CameraCubit>().checkCameraPermission(),
                  );
                }
                unawaited(
                  AnalyticsHelper.logEvent(
                    eventName:
                        AmplitudeEvents.generosityChallengeTakePictureClicked,
                  ),
                );
              },
              leftIcon: FontAwesomeIcons.camera,
              text: 'Take Picture',
            ),
            const SizedBox(height: 8),
            FunButton.secondary(
              onTap: () async {
                final success = await cubit.submitDay5Picture(
                  takenWithCamera: false,
                );
                if (context.mounted && !success) {
                  unawaited(
                    context.read<CameraCubit>().checkGalleryPermission(),
                  );
                }
                unawaited(
                  AnalyticsHelper.logEvent(
                    eventName:
                        AmplitudeEvents.generosityChallengeUploadPictureClicked,
                  ),
                );
              },
              leftIcon: FontAwesomeIcons.image,
              text: 'Upload Picture',
            ),
          ],
        ),
      ),
    );
  }
}
