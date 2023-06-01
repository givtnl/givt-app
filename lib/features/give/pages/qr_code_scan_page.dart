import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/give/bloc/give_cubit.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanPage extends StatefulWidget {
  const QrCodeScanPage({super.key});

  @override
  State<QrCodeScanPage> createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  bool _isLoading = false;
  final _controller = MobileScannerController();

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
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
      body: BlocListener<GiveCubit, GiveState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is GiveError) {
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
          if (state is GiveLoaded) {
            Navigator.of(context).pop(state.organisation);
          }
        },
        child: Stack(
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: onQRCodeDetected,
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

  Future<void> onQRCodeDetected(BarcodeCapture code) async {
    toggleLoading();
    await _controller.stop();
    if (code.barcodes.first.rawValue == null) {
      toggleLoading();
      log('No Givt QR code detected');
      return;
    }

    // ignore: use_build_context_synchronously
    if (!context.mounted) return;

    await context
        .read<GiveCubit>()
        .getOrganization(code.barcodes.first.rawValue!);
    toggleLoading();
  }
}
