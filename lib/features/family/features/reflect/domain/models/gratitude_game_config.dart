class GratitudeGameConfig {
  GratitudeGameConfig({
    required this.questions,
    required this.secretWords,
    this.isAiAllowed = false,
    this.storeReviewGameCount = 2,
    this.interviewGameCount = 1,
    this.useDefaultInterviewIcon = true,
    this.askForInterviewTitle = 'Earn \$50 for helping us!',
    this.askForInterviewMessage =
        'We’d love to hear your feedback about Givt on a quick call.',
  });

  factory GratitudeGameConfig.fromJson(Map<String, dynamic> json) {
    final questions = json['questions'] as List<dynamic>? ?? [];
    final secretWords = json['secret_words'] as List<dynamic>? ?? [];
    final isAiAllowed = json['is_ai_allowed'] as bool? ?? false;
    final storeReviewGameCount = json['store_review_game_count'] as int? ?? 2;
    final interviewGameCount = json['interview_game_count'] as int? ?? 1;
    final useDefaultInterviewIcon =
        json['use_default_interview_icon'] as bool? ?? true;
    final askForInterviewTitle = json['ask_for_interview_title'] as String? ??
        'Earn \$50 for helping us!';
    final askForInterviewMessage =
        json['ask_for_interview_message'] as String? ??
            'We’d love to hear your feedback about Givt on a quick call.';

    return GratitudeGameConfig(
      questions: questions.cast<String>(),
      secretWords: secretWords.cast<String>(),
      isAiAllowed: isAiAllowed,
      storeReviewGameCount: storeReviewGameCount,
      interviewGameCount: interviewGameCount,
      useDefaultInterviewIcon: useDefaultInterviewIcon,
      askForInterviewTitle: askForInterviewTitle,
      askForInterviewMessage: askForInterviewMessage,
    );
  }

  final List<String> questions;
  final List<String> secretWords;
  final bool isAiAllowed;
  final int storeReviewGameCount;
  final int interviewGameCount;
  final bool useDefaultInterviewIcon;
  final String askForInterviewTitle;
  final String askForInterviewMessage;

  Map<String, dynamic> toJson() {
    return {
      'questions': questions,
      'secret_words': secretWords,
      'is_ai_allowed': isAiAllowed,
      'store_review_game_count': storeReviewGameCount,
      'interview_game_count': interviewGameCount,
      'use_default_interview_icon': useDefaultInterviewIcon,
      'ask_for_interview_title': askForInterviewTitle,
      'ask_for_interview_message': askForInterviewMessage,
    };
  }

  bool isEmpty() {
    return questions.isEmpty || secretWords.isEmpty;
  }
}
