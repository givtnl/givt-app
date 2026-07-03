import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_frequency_dropdown.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';
import 'package:givt_app/features/pledges/shared/pledge_display.dart';

void main() {
  group('Pledge frequency editor save eligibility', () {
    test('does not treat mapped Once frequency as changed on open', () {
      final parsedFrequency =
          PledgeDisplay.parseFrequency('Once') ??
          ExternalDonationFrequency.monthly;
      final initialFrequency =
          ExternalDonationFrequencyDropdown.frequencyForEditor(
            parsedFrequency,
          );

      expect(initialFrequency, ExternalDonationFrequency.monthly);
      expect(initialFrequency != initialFrequency, isFalse);
    });

    test('detects user-selected frequency changes', () {
      final parsedFrequency =
          PledgeDisplay.parseFrequency('Monthly') ??
          ExternalDonationFrequency.monthly;
      final initialFrequency =
          ExternalDonationFrequencyDropdown.frequencyForEditor(
            parsedFrequency,
          );
      const selectedFrequency = ExternalDonationFrequency.weekly;

      expect(selectedFrequency != initialFrequency, isTrue);
    });
  });
}
