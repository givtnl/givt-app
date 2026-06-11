import 'package:equatable/equatable.dart';

class QrCode extends Equatable {
  QrCode({
    required this.name,
    required this.instance,
    required this.isActive,
    this.isGeneric = false,
  }) : nameSpace = instance.split('.').first;

  const QrCode.empty()
      : name = '',
        instance = '',
        isActive = false,
        isGeneric = true,
        nameSpace = '';

  factory QrCode.fromJson(Map<String, dynamic> json) {
    final name = json['N'] != null ? json['N'] as String : '';
    return QrCode(
      name: name,
      instance: json['I'] as String,
      isActive: json['A'] as bool,
      isGeneric: name.isEmpty,
    );
  }

  final String name;
  final String instance;
  final bool isActive;
  final bool isGeneric;
  final String nameSpace;

  Map<String, dynamic> toJson() {
    return {
      'N': name,
      'I': instance,
      'A': isActive,
    };
  }

  QrCode copyWith({
    String? name,
    String? instance,
    bool? isActive,
    bool? isGeneric,
  }) {
    return QrCode(
      name: name ?? this.name,
      instance: instance ?? this.instance,
      isActive: isActive ?? this.isActive,
      isGeneric: isGeneric ?? this.isGeneric,
    );
  }

  @override
  List<Object?> get props => [name, instance, isActive, isGeneric, nameSpace];
}
