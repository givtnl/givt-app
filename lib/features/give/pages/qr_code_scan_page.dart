import 'package:flutter/material.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanPage extends StatefulWidget {
  const QrCodeScanPage({super.key});

  static MaterialPageRoute<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const QrCodeScanPage(),
      fullscreenDialog: true,
    );
  }

  @override
  State<QrCodeScanPage> createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  bool _isLoading = false;

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
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
      body: Stack(
        children: [
          MobileScanner(
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
    );
  }

  void onQRCodeDetected(BarcodeCapture code) async {
    toggleLoading();
    // TODO: Add logic to handle the QR code
    
    toggleLoading();
  }
}
