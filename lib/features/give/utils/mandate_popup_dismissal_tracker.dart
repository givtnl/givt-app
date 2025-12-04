import 'package:givt_app/utils/shared_preferences_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MandatePopupDismissalTracker {
  MandatePopupDismissalTracker(this._prefs);

  final SharedPreferences _prefs;

  static const int maxDismissals = 3;

  int get dismissals =>
      _prefs.getInt(NativeSharedPreferencesKeys.mandatePopupDismissals) ?? 0;

  bool get shouldForceCompletion => dismissals >= maxDismissals;

  Future<void> incrementDismissals() async {
    await _prefs.setInt(
      NativeSharedPreferencesKeys.mandatePopupDismissals,
      dismissals + 1,
    );
  }

  Future<void> reset() async {
    await _prefs.setInt(
      NativeSharedPreferencesKeys.mandatePopupDismissals,
      0,
    );
  }
}
