import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/give/utils/mandate_popup_dismissal_tracker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences sharedPreferences;
  late MandatePopupDismissalTracker tracker;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    tracker = MandatePopupDismissalTracker(sharedPreferences);
  });

  test('dismissal count starts at zero', () {
    expect(tracker.dismissals, 0);
    expect(tracker.shouldForceCompletion, isFalse);
  });

  test('after reaching max dismissals flow becomes mandatory', () async {
    for (var i = 0; i < MandatePopupDismissalTracker.maxDismissals; i++) {
      await tracker.incrementDismissals();
    }

    expect(tracker.dismissals, MandatePopupDismissalTracker.maxDismissals);
    expect(tracker.shouldForceCompletion, isTrue);
  });

  test('dismissals persist across instances', () async {
    await tracker.incrementDismissals();
    expect(tracker.dismissals, 1);

    final newTracker = MandatePopupDismissalTracker(sharedPreferences);
    expect(newTracker.dismissals, 1);

    await newTracker.incrementDismissals();
    expect(newTracker.dismissals, 2);

    final thirdTracker = MandatePopupDismissalTracker(sharedPreferences);
    expect(thirdTracker.dismissals, 2);
  });

  test('incrementing beyond max dismissals', () async {
    for (var i = 0; i < MandatePopupDismissalTracker.maxDismissals + 2; i++) {
      await tracker.incrementDismissals();
    }
    expect(tracker.shouldForceCompletion, isTrue);
    expect(tracker.dismissals, MandatePopupDismissalTracker.maxDismissals + 2);
  });

  test('reset functionality clears dismissals', () async {
    // Increment dismissals to max
    for (var i = 0; i < MandatePopupDismissalTracker.maxDismissals; i++) {
      await tracker.incrementDismissals();
    }
    expect(tracker.dismissals, MandatePopupDismissalTracker.maxDismissals);
    expect(tracker.shouldForceCompletion, isTrue);

    // Reset dismissals
    await tracker.reset();
    expect(tracker.dismissals, 0);
    expect(tracker.shouldForceCompletion, isFalse);

    // Verify reset persists across instances
    final newTracker = MandatePopupDismissalTracker(sharedPreferences);
    expect(newTracker.dismissals, 0);
    expect(newTracker.shouldForceCompletion, isFalse);
  });
}
