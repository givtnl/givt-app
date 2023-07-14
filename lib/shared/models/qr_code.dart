import 'package:equatable/equatable.dart';

class QrCode extends Equatable {
  QrCode({
    required this.name,
    required this.instance,
    required this.isActive,
  }) : nameSpace = instance.split('.').first;

  const QrCode.empty()
      : name = '',
        instance = '',
        isActive = false,
        nameSpace = '';

  factory QrCode.fromJson(Map<String, dynamic> json) {
    return QrCode(
      name: json['N'] != null ? json['N'] as String : '',
      instance: json['I'] as String,
      isActive: json['A'] as bool,
    );
  }

  final String name;
  final String instance;
  final bool isActive;
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
  }) {
    return QrCode(
      name: name ?? this.name,
      instance: instance ?? this.instance,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [name, instance, isActive, nameSpace];
}
