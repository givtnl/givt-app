import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/pages/giving_page.dart';
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
  bool _isLoading = false;
  final _controller = MobileScannerController(autoStart: false);

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    isAllowed();
  }

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
          // await _controller.start();
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
              locals.giveDiffQRText,
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
                  title: Text(locals.qRScanFailed),
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
          if (state.status == GiveStatus.readyToGive) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => BlocProvider.value(
                  value: context.read<GiveBloc>(),
                  child: const GivingPage(),
                ),
                fullscreenDialog: true,
              ),
            );
          }
        },
        child: Stack(
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: _onQRCodeDetected,
              errorBuilder: (p0, p1, p2) {
                return Container();
              },
            ),
            const Positioned.fill(
              child: QrCodeTarget(),
            ),
            if (_isLoading)
              const Opacity(
                opacity: 0.8,
                child: ModalBarrier(dismissible: false, color: Colors.black),
              ),
            if (_isLoading)
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

  Future<void> _onQRCodeDetected(BarcodeCapture code) async {
    toggleLoading();
    await _controller.stop();
    if (code.barcodes.first.rawValue == null) {
      toggleLoading();
      log('No Givt QR code detected');
      return;
    }

    // ignore: use_build_context_synchronously
    if (!context.mounted) return;
    final userGUID = (context.read<AuthCubit>().state as AuthSuccess).user.guid;
    context
        .read<GiveBloc>()
        .add(GiveQRCodeScanned(code.barcodes.first.rawValue!, userGUID));
    toggleLoading();
  }
}
