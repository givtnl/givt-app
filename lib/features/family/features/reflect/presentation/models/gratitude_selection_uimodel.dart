import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';

class TagSelectionUimodel {
  const TagSelectionUimodel({
    required this.tagList,
    required this.sideKick,
    required this.reporter,
    this.selectedTag,
    this.superheroName,
  });

  final List<TagCategory> tagList;
  final TagCategory? selectedTag;
  final String? superheroName;
  final GameProfile sideKick;
  final GameProfile reporter;
}
