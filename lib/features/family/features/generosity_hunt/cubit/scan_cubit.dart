import 'package:flutter/foundation.dart';
import 'package:givt_app/features/family/features/generosity_hunt/app/generosity_hunt_repository.dart';
import 'package:givt_app/features/family/features/generosity_hunt/cubit/level_select_cubit.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

part 'scan_custom.dart';
part 'scan_uimodel.dart';

class ScanCubit extends CommonCubit<ScanUIModel, ScanCustom> {
  ScanCubit(this._repository) : super(const BaseState.loading()) {
    _repository.addListener(_emitData);
  }

  final GenerosityHuntRepository _repository;
  bool _scanningBarcode = false;
  String? _currentProfileId;

  // TODO: Fetch from repo when we have the API
  int _itemsRemaining = 1;

  void init(String currentProfileId) {
    _scanningBarcode = true;
    _currentProfileId = currentProfileId;
    _emitData();
  }

  void _emitData() {
    emitData(_createUIModel());
  }

  ScanUIModel _createUIModel() {
    final selectedLevel = _repository.selectedLevel;
    final level = _repository.getLevelByNumber(selectedLevel);
    return ScanUIModel(
      selectedLevel: selectedLevel,
      level: level,
      levelFinished: _itemsRemaining == 0,
    );
  }

  @override
  Future<void> close() {
    _repository.removeListener(_emitData);
    return super.close();
  }

  Future<void> onBarcodeDetected(BarcodeCapture barcodeCapture) async {
    final barcode = barcodeCapture.barcodes.firstOrNull;

    if (barcode == null || barcode.rawValue == null) return;
    if (!_scanningBarcode) return;

    // Stop accepting new barcodes
    _scanningBarcode = false;

    // Loading state
    emitCustom(const ScanCustom.barcodeFound());

    try {
      final response = await _repository.scanBarcode(
        barcode.rawValue!,
        _currentProfileId!,
      );
      if (response.item != null) {
        _itemsRemaining = response.item!.itemsRemaining;

        _emitData();
        emitCustom(
          ScanCustom.successFullScan(
            response.item!.creditsEarned,
            response.item!.itemsRemaining,
          ),
        );

        return;
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }

    emitCustom(const ScanCustom.notRecognized());
  }

  void restartScan() {
    emitCustom(const ScanCustom.stopSpinner());
    _scanningBarcode = true;
    _emitData();
  }

  Future<void> completeLevel() async {
    await _repository.fetchUserState(_currentProfileId!);
    emitData(_createUIModel());
  }
}
