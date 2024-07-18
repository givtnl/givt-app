import 'package:givt_app/features/family/features/admin_fee/presentation/models/admin_fee_uimodel.dart';

class AdminFee {
  const AdminFee({
    required this.startAmount,
    required this.amountPerExtraDollar,
    required this.maxAmount,
  });

  factory AdminFee.fromMap(Map<String, dynamic> map) {
    return AdminFee(
      startAmount: map['startAmount'] as double,
      amountPerExtraDollar: map['amountPerExtraDollar'] as double,
      maxAmount: map['maxAmount'] as double,
    );
  }

  factory AdminFee.initial() {
    return const AdminFee(
      startAmount: 0.30,
      amountPerExtraDollar: 0.08,
      maxAmount: 1,
    );
  }

  double getTotalFee(double amount) {
    if (amount <= 0) return 0;
    final extraAmount = amount > 1 ? (amount - 1) * amountPerExtraDollar : 0;
    final total = extraAmount + startAmount;
    return total > maxAmount ? maxAmount : total;
  }

  AdminFeeUIModel toUIModel(double amount) {
    return AdminFeeUIModel(fee: getTotalFee(amount));
  }

  final double startAmount;
  final double amountPerExtraDollar;
  final double maxAmount;
}
