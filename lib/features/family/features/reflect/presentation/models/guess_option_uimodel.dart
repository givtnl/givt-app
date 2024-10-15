class GuessOptionUIModel {
  GuessOptionUIModel({
    required this.text,
    this.state = GuessButtonState.initial,
  });

  final GuessButtonState state;
  final String text;
}

enum GuessButtonState { correct, wrong, initial }
