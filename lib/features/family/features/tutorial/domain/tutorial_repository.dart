import 'dart:async';

import 'package:rxdart/rxdart.dart';

class TutorialRepository {
  final BehaviorSubject<void> _startTutorialStream =
  BehaviorSubject();

  Stream<void> onStartTutorial() => _startTutorialStream.stream;

  void startTutorial() {
    _startTutorialStream.add(null);
  }
}
