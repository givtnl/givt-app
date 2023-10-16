import 'package:equatable/equatable.dart';
import 'package:givt_app/features/amount_presets/models/models.dart';

class AmountPresets extends Equatable {
  const AmountPresets({
    required this.presets,
  });

  factory AmountPresets.fromJson(Map<String, dynamic> json) => AmountPresets(
        presets: (json['amountPresets'] as List<dynamic>)
            .map((e) => UserPresets.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  const AmountPresets.empty() : presets = const [];

  final List<UserPresets> presets;

  void updateUserPresets(UserPresets newUserPresets) {
    presets
      ..removeWhere((oldPreset) => oldPreset.guid == newUserPresets.guid)
      ..add(newUserPresets);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'amountPresets': presets.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [presets];

  static const String tag = 'amountPresets';
}
