class GratitudeGameConfig {
  GratitudeGameConfig({
    required this.questions,
    required this.secretWords,
  });

  factory GratitudeGameConfig.fromJson(Map<String, dynamic> json) {
    final questions = json['questions'] as List<dynamic>? ?? [];
    final secretWords = json['secret_words'] as List<dynamic>? ?? [];
    return GratitudeGameConfig(
      questions: questions.cast<String>(),
      secretWords: secretWords.cast<String>(),
    );
  }

  final List<String> questions;
  final List<String> secretWords;

  Map<String, dynamic> toJson() {
    return {
      'questions': questions,
      'secret_words': secretWords,
    };
  }

  bool isEmpty() {
    return questions.isEmpty || secretWords.isEmpty;
  }
}
