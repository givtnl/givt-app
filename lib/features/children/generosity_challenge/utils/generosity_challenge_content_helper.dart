// ignore_for_file: prefer_asserts_with_message

import 'package:givt_app/features/children/generosity_challenge/models/task.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';

class GenerosityChallengeContentHelper {
  static const List<Task> _tasks = [
    Task.card(
      image: '//TODO',
      title: 'In a small village',
      description:
          "Lived a craftsman Geppetto. One day he decided to make a wooden toy. He said to himself, 'I will make a little boy and call him Pinocchio.'",
    ),
    Task.card(
      image: '',
      title: '',
      description: '',
    ),
    Task.card(
      image: '',
      title: '',
      description: '',
    ),
    Task.card(
      image: '',
      title: '',
      description: '',
    ),
    Task.card(
      image: '',
      title: '',
      description: '',
    ),
    Task.card(
      image: '',
      title: '',
      description: '',
    ),
    Task.card(
      image: '',
      title: '',
      description: '',
    ),
    Task.card(
      image: '',
      title: '',
      description: '',
    ),
    Task.card(
      image: '',
      title: '',
      description: '',
    ),
    Task.card(
      image: '',
      title: '',
      description: '',
    ),
    Task.card(
      image: '',
      title: '',
      description: '',
    ),
    Task.card(
      image: '',
      title: '',
      description: '',
    ),
  ];

  static Task getTaskByIndex(int index) {
    assert(_tasks.length == GenerosityChallengeHelper.generosityChallengeDays);
    return _tasks[index];
  }
}
