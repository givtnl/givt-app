import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:givt_app/features/family/features/generosity_hunt/cubit/level_select_cubit.dart';
import 'package:givt_app/features/family/features/generosity_hunt/models/scan_response.dart';
import 'package:givt_app/features/family/features/generosity_hunt/models/user_state_response.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

class GenerosityHuntRepository extends ChangeNotifier {
  GenerosityHuntRepository(this._apiService);

  int? _selectedLevel;
  List<dynamic>? _levels;
  String? _gameId;
  ScanResponse? _lastScanResponse;
  UserStateItem? _userState;
  final FamilyAPIService _apiService;

  int? get selectedLevel => _selectedLevel;
  List<dynamic>? get levels => _levels;
  String? get gameId => _gameId;
  ScanResponse? get lastScanResponse => _lastScanResponse;
  UserStateItem? get userState => _userState;

  Future<void> fetchLevels() async {
    _levels = await _apiService.fetchGenerosityHuntLevels();
    notifyListeners();
  }

  Future<void> fetchUserState(String userId) async {
    try {
      final response = await _apiService.fetchGenerosityHuntUserState(userId);
      _userState = UserStateItem.fromJson(response);
      notifyListeners();
    } catch (e) {
      // If user state fetch fails, default to level 1
    }
  }

  bool isLevelUnlocked(int level) {
    if (_userState == null) return level == 1; // Default to only first level unlocked
    
    final currentLevel = _userState!.currentLevel;
    final isCompleted = _userState!.isCompleted;
    
    // If current level is completed, unlock the next level
    if (isCompleted) {
      return level <= currentLevel + 1;
    } else {
      // If current level is not completed, unlock up to current level
      return level <= currentLevel;
    }
  }

  bool isLevelCompleted(int level) {
    if (_userState == null) return false;
    
    final currentLevel = _userState!.currentLevel;
    final isCompleted = _userState!.isCompleted;
    
    // A level is completed if:
    // 1. It's less than the current level (previous levels are completed)
    // 2. It's the current level AND the current level is completed
    return level < currentLevel || (level == currentLevel && isCompleted);
  }

  void setLevel(int level) {
    _selectedLevel = level;
    notifyListeners();
  }

  void setGameId(String gameId) {
    _gameId = gameId;
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

      setGameId(_gameId!);
      unawaited(fetchUserState(userId));
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
    );
  }
}
