import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';

class RecommendationsUIModel {
  RecommendationsUIModel({
    this.name,
    this.category,
    this.isLoading = false,
    this.isNotLoggedInParent = false,
    this.hasError = false,
    this.organisations = const [],
    this.showActsOfService = false,
  });

  final List<Organisation> organisations;
  final bool showActsOfService;
  final String? name;
  final GratitudeCategory? category;
  final bool isNotLoggedInParent;
  final bool isLoading;
  final bool hasError;
}
