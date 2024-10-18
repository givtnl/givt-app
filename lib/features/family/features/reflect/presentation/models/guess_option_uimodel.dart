class GuessOptionUIModel {
  GuessOptionUIModel({
    required this.text,
    this.state = GuessOptionState.initial,
  });

  final GuessOptionState state;
  final String text;
}

enum GuessOptionState { correct, wrong, initial }
