import 'package:flutter/foundation.dart';

class BarcodeHuntRepository extends ChangeNotifier {
  int? _selectedLevel;

  int? get selectedLevel => _selectedLevel;

  void setLevel(int level) {
    _selectedLevel = level;
    notifyListeners();
  }
} 