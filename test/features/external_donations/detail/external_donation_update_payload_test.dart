import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_update_payload.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_update_scope.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';

void main() {
  group('ExternalDonationUpdatePayload.frequency', () {
    final anchorDate = DateTime(2024, 6, 12);

    test('all scope includes startDate for full history recalculation', () {
      final body = ExternalDonationUpdatePayload.frequency(
        frequency: ExternalDonationFrequency.monthly,
        anchorDate: anchorDate,
        scope: ExternalDonationUpdateScope.all,
      );

      expect(body['frequency'], 'Monthly');
      expect(body['scope'], 0);
      expect(body['startDate'], '2024-06-12T00:00:00.000');
    });

    test('onwards scope omits startDate so past records are preserved', () {
      final body = ExternalDonationUpdatePayload.frequency(
        frequency: ExternalDonationFrequency.weekly,
        anchorDate: anchorDate,
        scope: ExternalDonationUpdateScope.onwards,
      );

      expect(body['frequency'], 'Weekly');
      expect(body['scope'], 1);
      expect(body.containsKey('startDate'), isFalse);
    });
  });
}
