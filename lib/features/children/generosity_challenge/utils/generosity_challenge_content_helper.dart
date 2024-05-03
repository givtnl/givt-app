// ignore_for_file: prefer_asserts_with_message

import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/children/generosity_challenge/models/task.dart';

class GenerosityChallengeContentHelper {
  static final List<Task> _tasks = [
    Task.card(
      image: 'assets/images/generosity_challenge_placeholder.svg',
      title: 'In a small village',
      description:
          "Lived a craftsman Geppetto. One day he decided to make a wooden toy. He said to himself, 'I will make a little boy and call him Pinocchio.'",
      onTap: () {},
    ),
    Task.card(
      image: 'assets/images/generosity_challenge_day_2.svg',
      title: 'Select Family Values',
      description:
          'Chat together and pick 3 values from your welcome pack. These will help guide your decisions around generosity.\n\nMake sure everyone has at least 1 they want of the 3 chosen.',
      buttonText: 'Select 3 values',
      redirect: Pages.selectValues.path,
      onTap: () {},
      partnerCard: Task.card(
        image: 'assets/images/generosity_challenge_day_2.svg',
        title: 'The 3 Family Values are selected!',
        description: '',
        onTap: () {},
      ),
    ),
    Task.card(
      image: '',
      title: 'It was not an expensive piece of wood. ',
      description:
          'Far from it. Just a common block of firewood, one of those thick, solid logs that are put on the fire in winter to make cold rooms cozy and warm.',
      buttonText: 'Next',
      onTap: () {},
    ),
    Task.card(
      image: '',
      title: '',
      description:
          'I do not know how this really happened, yet the fact remains that one fine day this piece of wood found itself in the shop of an old carpenter. ',
      buttonText: 'Laugh',
      onTap: () {},
    ),
    Task.card(
      image: 'assets/images/generosity_challenge_placeholder.svg',
      title: 'Mastro Cherry was filled with joy. ',
      description: '',
      buttonText: '',
      onTap: () {},
    ),
    Task.card(
      image: '',
      title: '',
      description:
          'As soon as he saw that piece of wood, Mastro Cherry was filled with joy. Rubbing his hands together happily, he mumbled half to himself: “This has come in the nick of time. I shall use it to make the leg of a table.”',
      buttonText: 'joy!',
      onTap: () {},
    ),
    Task.card(
      image: '',
      title: 'What a look of surprise shone on Mastro Cherry’s face!',
      description:
          'His funny face became still funnier. He turned frightened eyes about the room to find out where that wee, little voice had come from and he saw no one! He looked under the bench—no one! He peeped inside the closet—no one! He searched among the shavings—no one!',
      buttonText: '',
      onTap: () {},
    ),
    Task.card(
      image: '',
      title: '',
      description:
          'He opened the door to look up and down the street—and still no one! “Oh, I see!” he then said, laughing and scratching his Wig. “It can easily be seen that I only thought I heard the tiny voice say the words! Well, well—to work once more.”',
      buttonText: '',
      onTap: () {},
    ),
    Task.card(
      image: 'assets/images/generosity_challenge_placeholder.svg',
      title: 'He struck a most solemn blow upon the piece of wood.',
      description: '“Oh, oh! You hurt!” cried the same far-away little voice.',
      buttonText: '',
      onTap: () {},
    ),
    Task.card(
      image: 'assets/images/generosity_challenge_placeholder.svg',
      title: 'Mastro Cherry grew dumb',
      description:
          'His eyes popped out of his head, his mouth opened wide, and his tongue hung down on his chin. As soon as he regained the use of his senses, he said, trembling and stuttering from fright.',
      buttonText: '',
      onTap: () {},
    ),
    Task.card(
      image: '',
      title: '',
      description: '',
      buttonText: 'Move on',
      onTap: () {},
    ),
    Task.card(
      image: '',
      title: '',
      description:
          '“Where did that voice come from, when there is no one around? Might it be that this piece of wood has learned to weep and cry like a child? I can hardly believe it. Here it is—a piece of common firewood, good only to burn in the stove, the same as any other.”',
      buttonText: '',
      onTap: () {},
    ),
    Task.card(
      image: '',
      title:
          'Yet—might someone be hidden in it? If so, the worse for him. I’ll fix him!',
      description: '',
      buttonText: 'Fix him!',
      onTap: () {},
    ),
    Task.card(
      image: 'assets/images/generosity_challenge_placeholder.svg',
      title: 'Goodness gracious me!',
      description:
          'Goodbye my friend! Goodbye! There are new heights yet to explore',
      buttonText: 'Move on',
      onTap: () {},
    ),
  ];

  static Task getTaskByIndex(int index) {
    // assert(_tasks.length == GenerosityChallengeHelper.generosityChallengeDays);
    return _tasks[index];
  }
}
