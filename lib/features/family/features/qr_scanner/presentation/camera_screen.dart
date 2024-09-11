import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/giving_flow/collectgroup_details/cubit/collectgroup_details_cubit.dart';
import 'package:givt_app/features/family/features/qr_scanner/cubit/camera_cubit.dart';
import 'package:givt_app/features/family/features/qr_scanner/widgets/camera_permissions_dialog.dart';
import 'package:givt_app/features/family/features/qr_scanner/widgets/camera_screen_frame.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    super.key,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final MobileScannerController _cameraController = MobileScannerController();

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocConsumer<CameraCubit, CameraState>(
      listener: (context, state) {
        final cameraCubit = context.read<CameraCubit>();
        log('camera state changed to $state');
        if (state.status == CameraStatus.scanned) {
          log('QR code scanned: ${state.qrValue} \n Getting organisation details');
          context
              .read<CollectGroupDetailsCubit>()
              .getOrganisationDetails(state.qrValue);
        }
        if (state.status == CameraStatus.permissionPermanentlyDeclined) {
          showDialog<void>(
            context: context,
            builder: (_) {
              return CameraPermissionsDialog(
                cameraCubit: cameraCubit,
                isSettings: true,
              );
            },
          );
        }
        if (state.status == CameraStatus.requestPermission) {
          showDialog<void>(
            context: context,
            builder: (_) {
              return CameraPermissionsDialog(cameraCubit: cameraCubit);
            },
          );
        }
      },
      builder: (context, state) {
        return BlocConsumer<CollectGroupDetailsCubit, CollectGroupDetailsState>(
          listener: (context, orgState) {
            log('organisation details state changed to $orgState');
            if (orgState is OrganisationDetailsSetState) {
              log('Organisation is set: ${orgState.collectgroup.name}');
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.qrCodeScanned,
                eventProperties: {
                  'goal_name': orgState.collectgroup.name,
                },
              );
              context.pushReplacementNamed(
                FamilyPages.familyChooseAmountSlider.name,
              );
            }
          },
          builder: (context, orgState) {
            return CameraScreenFrame(
              feedback: orgState is OrganisationDetailsErrorState
                  ? orgState.collectgroup.name
                  : state.feedback,
              child: Stack(
                children: [
                  if (state.status == CameraStatus.permissionGranted ||
                      state.status == CameraStatus.scanned)
                    _buildMobileScanner(context.read<CameraCubit>())
                  else
                    _buildDisabledCameraBox(),
                  Positioned.fill(
                    child: state.status == CameraStatus.scanned
                        ? _builCenterLoader()
                        : _buildQRCodeTarget(size),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMobileScanner(CameraCubit cameraCubit) {
    return MobileScanner(
      controller: _cameraController,
      onDetect: (barcode) async {
        if (cameraCubit.state.status == CameraStatus.scanned) return;
        await cameraCubit.scanQrCode(barcode);
      },
    );
  }

  Widget _buildDisabledCameraBox() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: FamilyAppTheme.disabledCameraGrey,
    );
  }

  Widget _buildQRCodeTarget(Size size) {
    return Center(
      child: SvgPicture.asset(
        'assets/family/images/qr_target_full.svg',
        width: size.width * 0.6,
        height: size.width * 0.6,
      ),
    );
  }

  Widget _builCenterLoader() {
    return const CustomCircularProgressIndicator();
  }
}
