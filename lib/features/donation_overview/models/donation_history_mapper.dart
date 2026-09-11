import 'package:givt_app/core/datetime/api_date_time.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_source.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';
import 'package:givt_app/features/donation_overview/models/donation_status.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';
import 'package:givt_app/utils/uk_gift_aid_tax_year.dart';

abstract final class DonationHistoryMapper {
  const DonationHistoryMapper._();

  static DonationItem fromHistoryJson(Map<String, dynamic> json) {
    final source = DonationHistorySource.fromJson(json['source'] as String?);
    final timestampRaw = json['timestamp'] as String?;
    final timestamp = timestampRaw != null
        ? ApiDateTime.parseLocal(timestampRaw) ??
            DateTime.tryParse(timestampRaw)
        : null;

    if (source == DonationHistorySource.external) {
      final frequency = _parseExternalFrequency(json);
      return DonationItem(
        id: 0,
        historyId: json['id'] as String?,
        amount: (json['amount'] as num).toDouble(),
        organisationName: json['organisationName'] as String? ?? '',
        organisationTaxDeductible: false,
        isGiftAidEnabled: false,
        status: DonationStatus.fromLegacyStatus(0),
        timeStamp: timestamp,
        mediumId: '',
        taxYear: timestamp != null ? ukGiftAidTaxYearIndexForDate(timestamp) : 0,
        donationType: 0,
        isExternal: true,
        externalDonationId: json['externalDonationId'] as String?,
        externalTransactionId: json['externalTransactionId'] as String? ??
            json['id'] as String?,
        externalFrequency: frequency,
      );
    }

    final givtId = int.tryParse(json['id'] as String? ?? '') ??
        (json['id'] as num?)?.toInt() ??
        0;

    return DonationItem(
      id: givtId,
      historyId: json['id']?.toString(),
      amount: (json['amount'] as num).toDouble(),
      organisationName: json['organisationName'] as String? ?? '',
      organisationTaxDeductible: false,
      isGiftAidEnabled: json['giftAidEnabled'] as bool? ?? false,
      status: DonationStatus.fromLegacyStatus(json['status'] as int? ?? 0),
      timeStamp: timestamp,
      mediumId: json['mediumId'] as String? ?? '',
      taxYear: timestamp != null ? ukGiftAidTaxYearIndexForDate(timestamp) : 0,
      donationType: json['donationType'] as int? ?? 0,
      platformFeeAmount: (json['platformFeeAmount'] as num?)?.toDouble(),
      collectId: json['collectId'] as int?,
      allocationName: (json['allocationName'] as String? ?? '').trim(),
      isExternal: false,
    );
  }

  static ExternalDonationFrequency _parseExternalFrequency(
    Map<String, dynamic> json,
  ) {
    final isRecurring = json['isRecurring'] as bool? ?? false;
    if (!isRecurring) {
      return ExternalDonationFrequency.once;
    }

    final frequency = json['frequency'] as String?;
    switch (frequency) {
      case 'Weekly':
        return ExternalDonationFrequency.weekly;
      case 'Monthly':
        return ExternalDonationFrequency.monthly;
      case 'Quarterly':
        return ExternalDonationFrequency.quarterly;
      case 'HalfYearly':
        return ExternalDonationFrequency.halfYearly;
      case 'Yearly':
        return ExternalDonationFrequency.yearly;
      case 'Once':
      case 'OneTime':
        return ExternalDonationFrequency.once;
      default:
        return isRecurring
            ? ExternalDonationFrequency.monthly
            : ExternalDonationFrequency.once;
    }
  }
}
