import 'dart:async';

import 'package:flutter/cupertino.dart';

class TutorialRepository {
  final StreamController<void> _startTutorialStream =
      StreamController<void>.broadcast();

  Stream<void> onStartTutorial() => _startTutorialStream.stream;

  void startTutorial() {
    if (!hasTutorialStarted) {
      hasTutorialStarted = true;
      _startTutorialStream.add(null);
    }
  }

  bool hasTutorialStarted = false;

  bool bedtimeMissionStartedFromTutorial = false;
}
