import 'package:givt_app/features/family/features/reflect/presentation/models/guess_option_uimodel.dart';

class GuessTheWordUIModel {
  GuessTheWordUIModel({
    required this.text,
    this.isGameFinished = false,
    this.areContinuationButtonsEnabled = false,
    this.guessOptions = const [],
  });

  final bool isGameFinished;
  final bool areContinuationButtonsEnabled;
  final String text;
  final List<GuessOptionUIModel> guessOptions;
}
