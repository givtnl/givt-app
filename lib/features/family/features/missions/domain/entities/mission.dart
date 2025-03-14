import 'package:equatable/equatable.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_uimodel.dart';

class Mission extends Equatable {
  const Mission({
    required this.missionKey,
    required this.title,
    required this.description,
    required this.progress,
    required this.path,
    this.showAchievedTooltip = false,
  });

  /// Create a Mission from JSON map.
  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      missionKey: json['missionKey'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      progress: (json['progress'] as num).toDouble(),
      path: json['path'] as String,
      showAchievedTooltip: json['showAchievedTooltip'] as bool?,
    );
  }

  FunMissionCardUIModel toUIModel() {
    return FunMissionCardUIModel(
      title: title,
      description: description,
      progress: GoalCardProgressUImodel(amount: progress),
      namedPage: path,
    );
  }

  /// A unique key for this mission (from MissionKeys).
  final String missionKey;
  final String title;
  final String description;
  final double progress; // 0.0 to 100.0
  final String path; // Optional named path for navigation
  final bool?
      showAchievedTooltip; // Show a tooltip when the mission is achieved

  bool isCompleted() => progress >= 100;

  /// Convenience method for updating properties.
  Mission copyWith({
    String? missionKey,
    String? title,
    String? description,
    String? icon,
    double? progress,
    String? namedPath,
    bool? showAchievedTooltip,
  }) {
    return Mission(
      missionKey: missionKey ?? this.missionKey,
      title: title ?? this.title,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      path: namedPath ?? this.path,
      showAchievedTooltip: showAchievedTooltip ?? this.showAchievedTooltip,
    );
  }

  /// Convert the Mission to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'missionKey': missionKey,
      'title': title,
      'description': description,
      'progress': progress,
      'namedPath': path,
      if (true == showAchievedTooltip)
        'showAchievedTooltip': showAchievedTooltip,
    };
  }

  @override
  List<Object?> get props => [
        missionKey,
        title,
        description,
        progress,
        path,
        showAchievedTooltip,
      ];
}
