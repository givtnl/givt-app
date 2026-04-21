import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/widgets/errors/scanner_error_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('shows progress + localized message while module downloads',
      (tester) async {
    const error = MobileScannerException(
      errorCode: MobileScannerErrorCode.genericError,
      errorDetails: MobileScannerErrorDetails(
        message: 'Waiting for the barcode module to be downloaded. Please wait.',
      ),
    );

    await tester.pumpWidget(_wrap(const ScannerErrorWidget(error: error)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Preparing scanner... This might take a moment.'),
        findsOneWidget);
  });

  testWidgets('shows generic error for other MobileScanner errors',
      (tester) async {
    const error = MobileScannerException(
      errorCode: MobileScannerErrorCode.permissionDenied,
    );

    await tester.pumpWidget(_wrap(const ScannerErrorWidget(error: error)));

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Whoops, something went wrong.'), findsOneWidget);
  });
}

