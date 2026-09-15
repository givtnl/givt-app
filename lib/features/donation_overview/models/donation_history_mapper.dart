import 'package:givt_app/core/datetime/api_date_time.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_source.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';
import 'package:givt_app/features/donation_overview/models/donation_status.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';
import 'package:givt_app/utils/uk_gift_aid_tax_year.dart';

abstract final class DonationHistoryMapper {
  const DonationHistoryMapper._();

  static DonationItem fromHistoryJson(Map<String, dynamic> json) {
    final source = DonationHistorySource.fromJson(json['source']);
    final timestampRaw = json['timestamp'] as String?;
    final timestamp = timestampRaw != null
        ? ApiDateTime.parseLocal(timestampRaw) ??
              DateTime.tryParse(timestampRaw)
        : null;

    if (source == DonationHistorySource.external) {
      final frequency = _parseExternalFrequency(json);
      return DonationItem(
        id: 0,
        historyId: json['id']?.toString(),
        amount: _readDouble(json['amount']) ?? 0,
        organisationName: _readOrganisationName(json),
        organisationTaxDeductible: false,
        isGiftAidEnabled: false,
        status: DonationStatus.fromLegacyStatus(0),
        timeStamp: timestamp,
        mediumId: '',
        taxYear: timestamp != null
            ? ukGiftAidTaxYearIndexForDate(timestamp)
            : 0,
        donationType: 0,
        isExternal: true,
        externalDonationId: json['externalDonationId']?.toString(),
        externalTransactionId:
            json['externalTransactionId']?.toString() ?? json['id']?.toString(),
        externalFrequency: frequency,
      );
    }

    final givtId = _readInt(json['id']) ?? 0;
    final platformFeeAmount = _readDouble(json['platformFeeAmount']);

    return DonationItem(
      id: givtId,
      historyId: json['id']?.toString(),
      amount: _readDouble(json['amount']) ?? 0,
      organisationName: _readOrganisationName(json),
      organisationTaxDeductible: false,
      isGiftAidEnabled: json['giftAidEnabled'] as bool? ?? false,
      status: DonationStatus.fromLegacyStatus(_readInt(json['status']) ?? 0),
      timeStamp: timestamp,
      mediumId: _readString(json, const ['mediumId', 'MediumId']),
      taxYear: timestamp != null ? ukGiftAidTaxYearIndexForDate(timestamp) : 0,
      donationType: _readInt(json['donationType']) ?? 0,
      platformFeeAmount: platformFeeAmount,
      platformFeeTransactionId: _resolvePlatformFeeTransactionId(
        json: json,
        givtId: givtId,
        platformFeeAmount: platformFeeAmount,
      ),
      collectId: _readInt(json['collectId']),
      allocationName: (json['allocationName'] as String? ?? '').trim(),
      collectGroupType: _readCollectGroupType(json['collectGroupType']),
      isExternal: false,
    );
  }

  static int? _resolvePlatformFeeTransactionId({
    required Map<String, dynamic> json,
    required int givtId,
    required double? platformFeeAmount,
  }) {
    final bffId = _readInt(json['platformFeeTransactionId']);
    if (bffId != null) {
      return bffId;
    }
    if (platformFeeAmount == null || platformFeeAmount <= 0) {
      return null;
    }
    if (givtId != 0) {
      return givtId;
    }
    final historyId = json['id']?.toString();
    if (historyId != null && historyId.isNotEmpty) {
      return historyId.hashCode;
    }
    return null;
  }

  static ExternalDonationFrequency _parseExternalFrequency(
    Map<String, dynamic> json,
  ) {
    final isRecurring = json['isRecurring'] as bool? ?? false;
    if (!isRecurring) {
      return ExternalDonationFrequency.once;
    }

    final frequency = json['frequency']?.toString();
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

  static String _readOrganisationName(Map<String, dynamic> json) {
    return _readString(
      json,
      const ['organisationName', 'OrganisationName', 'orgName', 'OrgName'],
    );
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String) {
        final trimmed = value.trim();
        if (trimmed.isNotEmpty) {
          return trimmed;
        }
      }
    }
    return '';
  }

  static String? _readCollectGroupType(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      return value.isEmpty ? null : value;
    }
    if (value is num) {
      return CollectGroupType.fromInt(value.toInt()).name;
    }
    return value.toString();
  }

  static int? _readInt(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static double? _readDouble(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }
}
