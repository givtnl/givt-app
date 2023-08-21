import 'package:equatable/equatable.dart';

class Preset extends Equatable {
  const Preset({required this.id, required this.amount});

  factory Preset.fromJson(Map<String, dynamic> json) {
    return Preset(
      id: json['id'] as int,
      amount: json['amount'] as double,
    );
  }

  final int id;
  final double amount;

  Preset copyWith({
    int? id,
    double? amount,
  }) {
    return Preset(
      id: id ?? this.id,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'amount': amount,
      };

  @override
  List<Object?> get props => [id, amount];
}
