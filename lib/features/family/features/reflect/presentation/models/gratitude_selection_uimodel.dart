import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';

class GratitudeSelectionUimodel {
  const GratitudeSelectionUimodel({
    required this.gratitudeList,
    required this.sideKick,
    required this.reporter,
    this.selectedGratitude,
    this.superheroName,
  });

  final List<GratitudeCategory> gratitudeList;
  final GratitudeCategory? selectedGratitude;
  final String? superheroName;
  final GameProfile sideKick;
  final GameProfile reporter;
}
