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
  });

  const GivtGroup.empty()
      : givts = const [],
        timeStamp = null,
        organisationName = '',
        status = 0,
        amount = 0,
        isGiftAidEnabled = false;

  final List<Givt> givts;
  final DateTime? timeStamp;
  final String organisationName;
  final int status;
  final double amount;
  final bool isGiftAidEnabled;

  GivtGroup copyWith({
    List<Givt>? givts,
    DateTime? timeStamp,
    String? organisation,
    int? status,
    double? amount,
    bool? isGiftAidEnabled,
  }) {
    return GivtGroup(
      givts: givts ?? this.givts,
      timeStamp: timeStamp ?? this.timeStamp,
      organisationName: organisation ?? this.organisationName,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      isGiftAidEnabled: isGiftAidEnabled ?? this.isGiftAidEnabled,
    );
  }

  @override
  List<Object?> get props => [
        givts,
        timeStamp,
        organisationName,
        status,
        amount,
        isGiftAidEnabled,
      ];
}
