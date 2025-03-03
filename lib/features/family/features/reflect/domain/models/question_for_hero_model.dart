class QuestionForHeroModel {
  const QuestionForHeroModel({
    this.question,
    this.summary,
  });

  factory QuestionForHeroModel.fromJson(Map<String, dynamic> json) {
    return QuestionForHeroModel(
      question: json['question'] as String?,
      summary: json['summary'] as String?,
    );
  }

  final String? question;
  final String? summary;
}
