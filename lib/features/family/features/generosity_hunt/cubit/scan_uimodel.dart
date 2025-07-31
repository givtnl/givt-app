part of 'scan_cubit.dart';

class ScanUIModel {
  const ScanUIModel({
    this.selectedLevel,
    this.level,
    this.levelFinished = false,
    this.scannedItems = 0,
  });

  final int? selectedLevel;
  final LevelUIModel? level;
  final bool levelFinished;
  final int scannedItems;
}
