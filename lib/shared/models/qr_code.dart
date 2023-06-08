import 'package:equatable/equatable.dart';

class QrCode extends Equatable {
  QrCode({
    required this.name,
    required this.mediumId,
    required this.isActive,
  }) : nameSpace = mediumId.split('.').first;

  factory QrCode.fromJson(Map<String, dynamic> json) {
    return QrCode(
      name: json['name'] as String,
      mediumId: json['mediumId'] as String,
      isActive: json['isActive'] as bool,
    );
  }

  final String name;
  final String mediumId;
  final bool isActive;
  final String nameSpace;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mediumId': mediumId,
      'isActive': isActive,
    };
  }

  QrCode copyWith({
    String? name,
    String? mediumId,
    bool? isActive,
  }) {
    return QrCode(
      name: name ?? this.name,
      mediumId: mediumId ?? this.mediumId,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [name, mediumId, isActive, nameSpace];
}
