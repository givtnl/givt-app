// ignore_for_file: prefer_asserts_with_message

import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/children/generosity_challenge/models/task.dart';

class GenerosityChallengeContentHelper {
  static final List<Task> _tasks = [
    Task.card(
      image: 'assets/images/generosity_challenge_day_1.svg',
      title: 'Save the letter',
      description:
          "Today's assignment is for each family member to answer the question in the Mayor's letter. Once you've done that, stick it on your fridge with the magnet where you will see it everyday!\n\nDone? Hit the Complete Button",
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
      image: 'assets/images/generosity_challenge_day_3.svg',
      title: 'Attention',
      description:
          'Take turns to share something you have done today or yesterday and practice giving your attention to each other.',
      onTap: () {},
    ),
    Task.card(
      image: 'assets/images/generosity_challenge_day_4.svg',
      title: 'Time to help',
      description:
          'Set a timer for 5 minutes and quickly do as many helpful tasks as you can like feeding the dog or washing dishes. When time\'s up, see how many tasks you\'ve completed. \n\nReady, set, go!',
      onTap: () {},
    ),
    Task.card(
      image: 'assets/images/generosity_challenge_day_5.svg',
      title: 'Sharing is caring',
      description:
          'Today’s assignment is for each family member to choose 1 item to give away and donate.\n\nWhat will you pick?',
      onTap: () {},
    ),
    Task.card(
      image: 'assets/images/generosity_challenge_day_6.svg',
      title: 'Words of kindness',
      description:
          'Each person say one nice thing you like about someone else.\n\nFor example, "I love it when you hug me if I\'m sad."',
      onTap: () {},
    ),
    Task.card(
      image: 'assets/images/generosity_challenge_day_7.svg',
      title: 'Giving together',
      buttonText: 'Find a charity',
      description:
          'Using your Family Values see what charities align with what you care about. Give to one of them.',
      redirect: Pages.displayValues.path,
      onTap: () {},
      partnerCard: Task.card(
        image: 'assets/images/generosity_challenge_day_7.svg',
        title: 'Giving together',
        description: '',
        onTap: () {},
      ),
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
