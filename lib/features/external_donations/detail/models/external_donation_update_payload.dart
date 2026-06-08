import 'package:givt_app/features/external_donations/detail/models/external_donation_update_scope.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';

/// Builds PUT bodies for `PUT /givtservice/v1/ExternalDonations/{id}`.
abstract final class ExternalDonationUpdatePayload {
  const ExternalDonationUpdatePayload._();

  static Map<String, dynamic> amount({
    required double amount,
    ExternalDonationUpdateScope? scope,
  }) {
    final body = <String, dynamic>{'amount': amount};
    if (scope != null) {
      body['scope'] = scope.apiValue;
    }
    return body;
  }

  static Map<String, dynamic> frequency({
    required ExternalDonationFrequency frequency,
    required DateTime anchorDate,
    ExternalDonationUpdateScope? scope,
  }) {
    final body = <String, dynamic>{
      'frequency': ExternalDonation.frequencyEnumToString(frequency),
      'startDate': _formatStartDate(anchorDate),
    };
    if (scope != null) {
      body['scope'] = scope.apiValue;
    }
    return body;
  }

  static Map<String, dynamic> startDate({
    required DateTime startDate,
  }) {
    return {
      'startDate': _formatStartDate(startDate),
    };
  }

  static Map<String, dynamic> oneOffDate({
    required DateTime date,
    double? amount,
  }) {
    final body = <String, dynamic>{
      'startDate': _formatStartDate(date),
    };
    if (amount != null) {
      body['amount'] = amount;
    }
    return body;
  }

  static String _formatStartDate(DateTime date) {
    return DateTime(date.year, date.month, date.day).toIso8601String();
  }
}
