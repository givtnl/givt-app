import 'package:equatable/equatable.dart';

class Mission extends Equatable {
  const Mission({
    required this.missionKey,
    required this.title,
    required this.description,
    required this.progress,
    this.icon,
  });

  /// Create a Mission from JSON map.
  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      missionKey: json['missionKey'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String?,
      progress: (json['progress'] as num).toDouble(),
    );
  }

  /// A unique key for this mission (from MissionKeys).
  final String missionKey;
  final String title;
  final String description;
  final String? icon; // can store an asset name or URL
  final double progress; // 0.0 to 1.0

  bool isCompleted() => progress >= 1;

  /// Convenience method for updating properties.
  Mission copyWith({
    String? missionKey,
    String? title,
    String? description,
    String? icon,
    double? progress,
    bool? isCompleted,
  }) {
    return Mission(
      missionKey: missionKey ?? this.missionKey,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      progress: progress ?? this.progress,
    );
  }

  /// Convert the Mission to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'missionKey': missionKey,
      'title': title,
      'description': description,
      'icon': icon,
      'progress': progress,
    };
  }

  @override
  List<Object?> get props => [
        missionKey,
        title,
        description,
        icon,
        progress,
      ];
}
