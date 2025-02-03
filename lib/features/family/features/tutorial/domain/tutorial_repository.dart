import 'dart:async';

class TutorialRepository {
  final StreamController<void> _startTutorialStream =
      StreamController<void>.broadcast();

  Stream<void> onStartTutorial() => _startTutorialStream.stream;

  void startTutorial() {
    _startTutorialStream.add(null);
  }

  bool bedtimeMissionStartedFromTutorial = false;
}
