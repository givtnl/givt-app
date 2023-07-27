import 'package:equatable/equatable.dart';
import 'package:givt_app/features/amount_presets/models/preset.dart';

class UserPresets extends Equatable {
  const UserPresets({
    this.isEnabled = false,
    this.presets = const [
      Preset(id: 1, amount: 2.50),
      Preset(id: 2, amount: 7.50),
      Preset(id: 3, amount: 12.50),
    ],
  });

  const UserPresets.empty()
      : isEnabled = false,
        presets = const [
          Preset(id: 1, amount: 2.50),
          Preset(id: 2, amount: 7.50),
          Preset(id: 3, amount: 12.50),
        ];

  factory UserPresets.fromJson(Map<String, dynamic> json) => UserPresets(
        isEnabled: json['isEnabled'] as bool,
        presets: (json['amountPresets'] as List<dynamic>)
            .map((e) => Preset.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  final bool isEnabled;
  final List<Preset> presets;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'isEnabled': isEnabled,
        'amountPresets': presets.map((e) => e.toJson()).toList(),
      };

  UserPresets copyWith({
    String? guid,
    bool? isEnabled,
    List<Preset>? presets,
  }) =>
      UserPresets(
        isEnabled: isEnabled ?? this.isEnabled,
        presets: presets ?? this.presets,
      );

  @override
  List<Object?> get props => [
        isEnabled,
        presets,
      ];
}
