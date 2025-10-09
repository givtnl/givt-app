import 'package:equatable/equatable.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart' as overview;

class RecurringDonation extends Equatable {
  const RecurringDonation({
    required this.amount,
    required this.frequency,
    required this.startDate,
    required this.namespace,
    this.endDate,
    this.maxRecurrencies,
  });

  final double amount;
  final overview.Frequency frequency;
  final DateTime startDate;
  final String namespace;
  final DateTime? endDate;
  final int? maxRecurrencies;

  Map<String, dynamic> toJson() {
    final json = {
      'amount': amount,
      'frequency': frequency.apiValue,
      'startDate': startDate.toIso8601String(),
      'namespace': namespace,
    };

    if (endDate != null) {
      json['endDate'] = endDate!.toIso8601String();
    }

    if (maxRecurrencies != null && maxRecurrencies! > 0) {
      json['numberOfTurns'] = maxRecurrencies!;
    }

    return json;
  }

  @override
  List<Object> get props => [
        amount,
        frequency,
        startDate,
        namespace,
        endDate ?? DateTime.now(),
        maxRecurrencies ?? 0,
      ];
}
