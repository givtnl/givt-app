import 'package:equatable/equatable.dart';

class MultiUseAllocation extends Equatable {
  const MultiUseAllocation({
    this.name = '',
    this.dtBeginCron = '',
    this.dtEndCron = '',
  });

  factory MultiUseAllocation.fromJson(Map<String, dynamic> json) {
    return MultiUseAllocation(
      name: json['Name'] as String,
      dtBeginCron: json['dtBeginCron'] as String,
      dtEndCron: json['dtEndCron'] as String,
    );
  }

  final String name;
  final String dtBeginCron;
  final String dtEndCron;

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'dtBeginCron': dtBeginCron,
      'dtEndCron': dtEndCron,
    };
  }

  MultiUseAllocation copyWith({
    String? name,
    String? dtBeginCron,
    String? dtEndCron,
  }) {
    return MultiUseAllocation(
      name: name ?? this.name,
      dtBeginCron: dtBeginCron ?? this.dtBeginCron,
      dtEndCron: dtEndCron ?? this.dtEndCron,
    );
  }

  @override
  List<Object?> get props => [
        name,
        dtBeginCron,
        dtEndCron,
      ];
}
