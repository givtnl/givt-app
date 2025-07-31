part of 'scan_cubit.dart';

sealed class ScanCustom {
  const ScanCustom();

  const factory ScanCustom.barcodeFound() = ScanCustomBarcodeFound;
  const factory ScanCustom.successFullScan(
    int creditsEarned,
    int itemsRemaining,
  ) = ScanCustomSuccessFullScan;
  const factory ScanCustom.notRecognized() = ScanCustomNotRecognized;
  const factory ScanCustom.stopSpinner() = ScanCustomStopSpinner;
}

class ScanCustomBarcodeFound extends ScanCustom {
  const ScanCustomBarcodeFound();
}

class ScanCustomSuccessFullScan extends ScanCustom {
  const ScanCustomSuccessFullScan(
    this.creditsEarned,
    this.itemsRemaining,
  );

  final int creditsEarned;
  final int itemsRemaining;
}

class ScanCustomNotRecognized extends ScanCustom {
  const ScanCustomNotRecognized();
}

class ScanCustomStopSpinner extends ScanCustom {
  const ScanCustomStopSpinner();
}