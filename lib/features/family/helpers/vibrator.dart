import 'package:vibration/vibration.dart';

class Vibrator {
  Vibrator._();

  static Future<void> tryVibrate({
    Duration duration = const Duration(milliseconds: 500),
  }) async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.cancel();
      Vibration.vibrate(duration: duration.inMilliseconds);
    }
  }

  static Future<void> tryVibratePattern({
    List<int> pattern = const [50, 600, 450, 80],
    List<int> intensities = const [0, 128, 0, 255],
  }) async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.cancel();
      Vibration.vibrate(
        pattern: pattern,
        intensities: intensities,
      );
    }
  }
}
