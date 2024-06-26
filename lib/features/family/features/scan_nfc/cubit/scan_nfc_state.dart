part of 'scan_nfc_cubit.dart';

enum ScanNFCStatus {
  ready,
  prescanning,
  scanning,
  scanned,
  nfcNotAvailable,
  error,
}

class ScanNfcState extends Equatable {
  const ScanNfcState({
    required this.scanNFCStatus,
    this.readData = '',
    this.mediumId = '',
  });
  final ScanNFCStatus scanNFCStatus;
  final String readData;
  final String mediumId;

  @override
  List<Object> get props => [scanNFCStatus, readData, mediumId];

  ScanNfcState copyWith({
    ScanNFCStatus? scanNFCStatus,
    String? readData,
    String? mediumId,
  }) {
    return ScanNfcState(
      scanNFCStatus: scanNFCStatus ?? this.scanNFCStatus,
      readData: readData ?? this.readData,
      mediumId: mediumId ?? this.mediumId,
    );
  }
}
