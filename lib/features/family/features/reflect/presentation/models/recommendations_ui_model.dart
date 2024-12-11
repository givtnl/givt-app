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
    this.tabIndex = 0,
    this.isShowingActsOfService = true,
  });

  final List<Organisation> organisations;
  final int tabIndex;
  final String? name;
  final TagCategory? category;
  final bool isNotLoggedInParent;
  final bool isLoading;
  final bool hasError;
  final bool isShowingActsOfService;
}
