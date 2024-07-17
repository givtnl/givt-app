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

  final double startAmount;
  final double amountPerExtraDollar;
  final double maxAmount;
}
