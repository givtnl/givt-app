enum RecommendationTypes {
  organisation('collectgroup'),
  church('church'),
  actOfService('actofservice');

  const RecommendationTypes(this.value);

  final String value;

  static RecommendationTypes fromString(String value) {
    final lowercaseValue = value.toLowerCase();
    return RecommendationTypes.values.firstWhere(
      (element) => element.value == lowercaseValue,
      orElse: () => RecommendationTypes.organisation,
    );
  }
}
