import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';

class GratitudeSelectionUimodel {
  const GratitudeSelectionUimodel({
    required this.gratitudeList,
    this.selectedGratitude,
  });

  final List<GratitudeCategory> gratitudeList;
  final GratitudeCategory? selectedGratitude;
}
