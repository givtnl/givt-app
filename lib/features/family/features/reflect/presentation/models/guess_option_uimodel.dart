class GuessOptionUIModel {
  GuessOptionUIModel({
    required this.text,
    this.state = GuessOptionState.initial,
    this.isCorrectOption = false,
  });

  final GuessOptionState state;
  final String text;
  final bool isCorrectOption;
}

enum GuessOptionState { correct, wrong, initial }
