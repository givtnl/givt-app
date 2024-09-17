import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/qr_scanner/cubit/camera_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/widgets/camera_permission_eu_dialog.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanPage extends StatefulWidget {
  const QrCodeScanPage({
    super.key,
  });

  @override
  State<QrCodeScanPage> createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  final _controller = MobileScannerController();
  final _cubit = getIt<CameraCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.checkCameraPermission();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final locals = context.l10n;
    final userGuid = context.read<AuthCubit>().state.user.guid;
    return BlocListener<CameraCubit, CameraState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state.status == CameraStatus.permissionPermanentlyDeclined) {
          showDialog<void>(
            context: context,
            builder: (_) {
              return CameraPermissionSettingsEuDialog(
                cameraCubit: _cubit,
                onCancel: () => context.pop(),
              );
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(locals.giveDifferentScan),
              Text(
                locals.giveDiffQrText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          toolbarHeight: size.height * 0.1,
        ),
        body: BlocConsumer<GiveBloc, GiveState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state.status == GiveStatus.error) {
              displayErrorDialog();
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: (BarcodeCapture barcodeCapture) async =>
                      _processBarcode(
                    barcodeCapture: barcodeCapture,
                    userGuid: userGuid,
                  ),
                ),
                const Positioned.fill(
                  child: QrCodeTarget(),
                ),
                if (state.status == GiveStatus.loading)
                  const Opacity(
                    opacity: 0.8,
                    child:
                        ModalBarrier(dismissible: false, color: Colors.black),
                  ),
                if (state.status == GiveStatus.loading)
                  const Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.givtLightGreen,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _processBarcode({
    required BarcodeCapture barcodeCapture,
    required String userGuid,
  }) async {
    await _controller.stop();
    if (barcodeCapture.barcodes.isEmpty) {
      log('No Givt QR code detected');
      return;
    }

    if (barcodeCapture.barcodes.first.rawValue == null) {
      log('QR code raw value is null');
      return;
    }

    if (!mounted) return;

    final encodedMediumId = isGivtQRCode(barcodeCapture.barcodes);

    if (encodedMediumId == null) {
      LoggingInfo.instance.info('QR-Code does not contain a medium id');
      await displayErrorDialog();
      return;
    }

    context.read<GiveBloc>().add(
          GiveQRCodeScanned(
            encodedMediumId,
            userGuid,
          ),
        );
  }

  /// Checks if the given barcodes contain a Givt QR code.
  /// Returns the encoded medium id if it is a Givt QR code,
  /// otherwise null.
  String? isGivtQRCode(List<Barcode> barcodes) {
    for (final barcode in barcodes) {
      final rawValue = barcode.rawValue;

      if (rawValue == null) {
        continue;
      }
      final uri = Uri.tryParse(rawValue);

      if (uri == null) {
        continue;
      }

      final encodedMediumId = uri.queryParameters['code'];

      if (encodedMediumId == null) {
        continue;
      }

      return encodedMediumId;
    }
    return null;
  }

  Future<void> displayErrorDialog() async {
    final locals = context.l10n;
    await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(locals.qrScanFailed),
          content: Text(locals.codeCanNotBeScanned),
          actions: [
            TextButton(
              onPressed: () {
                return Navigator.pop(context, true);
              },
              child: Text(locals.cancel),
            ),
            TextButton(
              onPressed: () {
                _controller.start();
                Navigator.of(context).pop();
              },
              child: Text(locals.tryAgain),
            ),
          ],
        );
      },
    ).then((bool? value) {
      if (value == null) {
        _controller.start();
      } else {
        Navigator.of(context).pop();
      }
    });
  }
}
