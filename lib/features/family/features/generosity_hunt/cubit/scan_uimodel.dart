part of 'scan_cubit.dart';

class ScanUIModel {
  const ScanUIModel({
    this.selectedLevel,
    this.level,
    this.levelFinished = false,
  });

  final int? selectedLevel;
  final LevelUIModel? level;
  final bool levelFinished;
}
