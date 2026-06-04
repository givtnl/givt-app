import 'package:givt_app/core/datetime/api_date_time.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';

/// Display helpers for [ExternalDonation] list and detail UI.
abstract final class ExternalDonationDisplay {
  /// Gift / series start date formatted for the user's locale and timezone.
  static String formatStartDate(ExternalDonation donation, String locale) {
    return ApiDateTime.formatYMMMd(donation.startDateTime, locale);
  }

  /// Locale-formatted calendar date for history rows and detail cards.
  static String formatDate(DateTime? date, String locale) {
    return ApiDateTime.formatYMMMd(date, locale);
  }
}
