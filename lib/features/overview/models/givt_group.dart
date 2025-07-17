import 'package:equatable/equatable.dart';
import 'package:givt_app/features/overview/models/models.dart';

class GivtGroup extends Equatable {
  const GivtGroup({
    required this.timeStamp,
    this.status = 0,
    this.isGiftAidEnabled = false,
    this.organisationName = '',
    this.givts = const [],
    this.amount = 0,
    this.taxYear = 0,
  });

  const GivtGroup.empty()
      : givts = const [],
        timeStamp = null,
        organisationName = '',
        status = 0,
        amount = 0,
        isGiftAidEnabled = false,
        taxYear = 0;

  final List<Givt> givts;
  final DateTime? timeStamp;
  final String organisationName;
  final int status;
  final double amount;
  final bool isGiftAidEnabled;
  final int taxYear;

  double get platformFeeAmount {
    final seenIds = <int>{};
    double sum = 0;
    for (final givt in givts) {
      final id = givt.platformFeeTransactionId;
      final fee = givt.platformFeeAmount;
      if (id != null && fee != null && !seenIds.contains(id)) {
        sum += fee;
        seenIds.add(id);
      }
    }
    return sum;
  }

  GivtGroup copyWith({
    List<Givt>? givts,
    DateTime? timeStamp,
    String? organisation,
    int? status,
    double? amount,
    bool? isGiftAidEnabled,
    int? taxYear,
  }) {
    return GivtGroup(
      givts: givts ?? this.givts,
      timeStamp: timeStamp ?? this.timeStamp,
      organisationName: organisation ?? organisationName,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      isGiftAidEnabled: isGiftAidEnabled ?? this.isGiftAidEnabled,
      taxYear: taxYear ?? this.taxYear,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'givts': givts.map((x) => x.toJson()).toList(),
      'timeStamp': timeStamp?.toIso8601String(),
      'organisationName': organisationName,
      'status': status,
      'amount': amount,
      'isGiftAidEnabled': isGiftAidEnabled,
      'taxYear': taxYear,
      'platformFeeAmount': platformFeeAmount,
    };
  }

  @override
  List<Object?> get props => [
        givts,
        timeStamp,
        organisationName,
        status,
        amount,
        isGiftAidEnabled,
        taxYear,
        platformFeeAmount,
      ];
}
