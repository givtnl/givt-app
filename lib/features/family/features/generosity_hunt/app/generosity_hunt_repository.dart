import 'package:flutter/foundation.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';
import 'package:givt_app/features/family/features/generosity_hunt/cubit/level_select_cubit.dart';

class GenerosityHuntRepository extends ChangeNotifier {
  int? _selectedLevel;
  List<dynamic>? _levels;
  final FamilyAPIService _apiService;

  GenerosityHuntRepository(this._apiService);

  int? get selectedLevel => _selectedLevel;
  List<dynamic>? get levels => _levels;

  Future<void> fetchLevels() async {
    _levels = await _apiService.fetchGenerosityHuntLevels();
    notifyListeners();
  }

  void setLevel(int level) {
    _selectedLevel = level;
    notifyListeners();
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
