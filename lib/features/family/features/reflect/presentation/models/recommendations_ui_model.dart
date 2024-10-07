import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';

class RecommendationsUIModel {
  RecommendationsUIModel({
    this.name,
    this.category,
    this.isLoading = false,
    this.hasError = false,
    this.organisations = const [],
  });

  final List<Organisation> organisations;
  final String? name;
  final GratitudeCategory? category;
  final bool isLoading;
  final bool hasError;
}
