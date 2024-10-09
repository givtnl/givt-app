enum RecommendationTypes {
  organisation('organisation'),
  church('church'),
  actOfService('actsofservice');

  const RecommendationTypes(this.value);

  final String value;

  static RecommendationTypes fromString(String value) {
    return RecommendationTypes.values.firstWhere(
      (element) => element.value == value,
      orElse: () => RecommendationTypes.organisation,
    );
  }
}
