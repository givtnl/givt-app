class GratitudeGameConfig {
  GratitudeGameConfig({
    required this.questions,
    required this.secretWords,
    this.isAiAllowed = false,
    this.storeReviewGameCount = 2,
  });

  factory GratitudeGameConfig.fromJson(Map<String, dynamic> json) {
    final questions = json['questions'] as List<dynamic>? ?? [];
    final secretWords = json['secret_words'] as List<dynamic>? ?? [];
    final isAiAllowed = json['is_ai_allowed'] as bool? ?? false;
    final storeReviewGameCount = json['store_review_game_count'] as int? ?? 2;

    return GratitudeGameConfig(
        questions: questions.cast<String>(),
        secretWords: secretWords.cast<String>(),
        isAiAllowed: isAiAllowed,
        storeReviewGameCount: storeReviewGameCount);
  }

  final List<String> questions;
  final List<String> secretWords;
  final bool isAiAllowed;
  final int storeReviewGameCount;

  Map<String, dynamic> toJson() {
    return {
      'questions': questions,
      'secret_words': secretWords,
      'is_ai_allowed': isAiAllowed,
      'store_review_game_count': storeReviewGameCount
    };
  }

  bool isEmpty() {
    return questions.isEmpty || secretWords.isEmpty;
  }
}
