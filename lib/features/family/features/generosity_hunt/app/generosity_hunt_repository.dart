import 'package:flutter/foundation.dart';
import 'package:givt_app/features/family/features/generosity_hunt/cubit/level_select_cubit.dart';
import 'package:givt_app/features/family/features/generosity_hunt/models/scan_response.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

class GenerosityHuntRepository extends ChangeNotifier {
  GenerosityHuntRepository(this._apiService);

  int? _selectedLevel;
  List<dynamic>? _levels;
  String? _gameId;
  ScanResponse? _lastScanResponse;
  final FamilyAPIService _apiService;

  int? get selectedLevel => _selectedLevel;
  List<dynamic>? get levels => _levels;
  String? get gameId => _gameId;
  ScanResponse? get lastScanResponse => _lastScanResponse;

  Future<void> fetchLevels() async {
    _levels = await _apiService.fetchGenerosityHuntLevels();
    notifyListeners();
  }

  void setLevel(int level) {
    _selectedLevel = level;
    notifyListeners();
  }

  Future<void> createGame(String userId) async {
    try {
      // For now, don't send user guids as requested
      final guids = <String>[userId];
      _gameId = await _apiService.createGame(
        guids: guids,
        type: 'GenerosityHunt',
      );
      notifyListeners();
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  Future<ScanResponse> scanBarcode(String barcode, String userId) async {
    try {
      _lastScanResponse = await _apiService.scanBarcode(
        userId: userId,
        barcode: barcode,
      );
      notifyListeners();
      return _lastScanResponse!;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  LevelUIModel? getLevelByNumber(int? level) {
    if (level == null || _levels == null) return null;
    final map = _levels!.cast<Map<String, dynamic>>();
    final found = map.firstWhere(
      (e) => e['level'] == level,
      orElse: () => {},
    );
    if (found.isEmpty) return null;
    final model = LevelUIModel.fromJson(found);
    // Always use the default image asset
    return LevelUIModel(
      level: model.level,
      itemsNeeded: model.itemsNeeded,
      funFact: model.funFact,
      title: model.title,
      subtitle: model.subtitle,
      description: model.description,
      assignment: model.assignment,
      imageAsset: 'assets/family/images/barcode_hunt/level_default_image.svg',
    );
  }
}
