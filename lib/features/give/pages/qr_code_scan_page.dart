import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QrCodeScanPage extends StatefulWidget {
  const QrCodeScanPage({super.key});

  @override
  State<QrCodeScanPage> createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  final _controller = MobileScannerController();

  Future<void> isAllowed() async {
    final isAllowed = await Permission.camera.isGranted;
    if (!mounted) return;
    if (isAllowed) {
      await _controller.start();
      return;
    }

    await showDialog<bool>(
      context: context,
      builder: (context) => PermissionDialog(
        title: context.l10n.accessDenied,
        content: context.l10n.cameraPermission,
        onTryAgain: () async {
          await Permission.camera.request();
          if (!mounted) return;
          Navigator.of(context).pop(true);
        },
        onCancel: () => Navigator.of(context).pop(false),
      ),
    ).then((value) {
      if (value == null) {
        Navigator.of(context).pop();
        return;
      }
      if (value) {
        _controller.start();
        setState(() {});
        return;
      }
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = AppLocalizations.of(context);
    return Scaffold(
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
      body: BlocListener<GiveBloc, GiveState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state.status == GiveStatus.error) {
            showDialog<bool>(
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
              }
              if (value!) {
                Navigator.of(context).pop();
              }
            });
          }
        },
        child: Stack(
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: (barcode, args) async {
                await _controller.stop();
                if (barcode.rawValue == null) {
                  log('No Givt QR code detected');
                  return;
                }

                if (!mounted) return;
                final userGUID = context.read<AuthCubit>().state.user.guid;
                context
                    .read<GiveBloc>()
                    .add(GiveQRCodeScanned(barcode.rawValue!, userGUID));
              },
            ),
            const Positioned.fill(
              child: QrCodeTarget(),
            ),
            if (context.watch<GiveBloc>().state.status == GiveStatus.loading)
              const Opacity(
                opacity: 0.8,
                child: ModalBarrier(dismissible: false, color: Colors.black),
              ),
            if (context.watch<GiveBloc>().state.status == GiveStatus.loading)
              const Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.givtLightGreen,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
