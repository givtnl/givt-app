import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({
    required this.error,
    super.key,
  });

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    final isDownloadingModule =
        (error.errorDetails?.message?.toLowerCase().contains('barcode module') ??
                false) ||
            (error.errorDetails?.details
                    ?.toString()
                    .toLowerCase()
                    .contains('barcode module') ??
                false);

    if (isDownloadingModule) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                locals.scannerDownloadingModule,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          locals.somethingWentWrong,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
