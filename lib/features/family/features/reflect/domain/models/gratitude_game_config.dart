class GratitudeGameConfig {
  GratitudeGameConfig({
    required this.questions,
    required this.secretWords,
    this.isAiAllowed = false,
  });

  factory GratitudeGameConfig.fromJson(Map<String, dynamic> json) {
    final questions = json['questions'] as List<dynamic>? ?? [];
    final secretWords = json['secret_words'] as List<dynamic>? ?? [];
    final isAiAllowed = json['is_ai_allowed'] as bool? ?? false;
    return GratitudeGameConfig(
      questions: questions.cast<String>(),
      secretWords: secretWords.cast<String>(),
      isAiAllowed: isAiAllowed,
    );
  }

  final List<String> questions;
  final List<String> secretWords;
  final bool isAiAllowed;

  Map<String, dynamic> toJson() {
    return {
      'questions': questions,
      'secret_words': secretWords,
      'is_ai_allowed': isAiAllowed,
    };
  }

  bool isEmpty() {
    return questions.isEmpty || secretWords.isEmpty;
  }
}
