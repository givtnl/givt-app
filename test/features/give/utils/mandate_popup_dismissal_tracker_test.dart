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
}
