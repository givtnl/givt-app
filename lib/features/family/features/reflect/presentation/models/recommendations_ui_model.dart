import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';

class RecommendationsUIModel {
  RecommendationsUIModel({
    this.name,
    this.isLoading = false,
    this.hasError = false,
    this.organisations = const [],
  });

  final List<Organisation> organisations;
  final String? name;
  final bool isLoading;
  final bool hasError;
}
