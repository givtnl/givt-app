import 'package:equatable/equatable.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';

class DonationHistoryResult extends Equatable {
  const DonationHistoryResult({
    required this.items,
    this.partialError = false,
  });

  final List<DonationItem> items;
  final bool partialError;

  @override
  List<Object?> get props => [items, partialError];
}
