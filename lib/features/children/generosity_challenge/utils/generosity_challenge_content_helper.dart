// ignore_for_file: prefer_asserts_with_message

import 'package:givt_app/features/children/generosity_challenge/models/task.dart';
import 'package:givt_app/features/family/app/family_pages.dart';

class GenerosityChallengeContentHelper {
  static final List<Task> _tasks = [
    _day1(),
    _day2(),
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
          'Each person say one nice thing you like about someone else.\n\nFor example, "I love it when you hug me when I\'m sad."',
      onTap: () {},
    ),
    _day7(),
    day8(),
  ];

  static Task _day2() {
    return Task.card(
      image: 'assets/images/generosity_challenge_day_2.svg',
      title: 'Select Family Values',
      description:
          'Chat together and pick 3 values from your welcome pack. These will help guide your decisions around generosity.\n\nMake sure everyone has at least 1 they want of the 3 chosen.',
      buttonText: 'Select 3 values',
      redirect: FamilyPages.selectValues.path,
      onTap: () {},
      partnerCard: Task.card(
        image: 'assets/images/generosity_challenge_day_2.svg',
        title: 'The 3 Family Values are selected!',
        description: '',
        onTap: () {},
      ),
    );
  }

  static Task _day1() {
    return Task.card(
      image: 'assets/images/generosity_challenge_day_1.svg',
      title: 'Save the letter',
      description:
          "Today's assignment is for each family member to answer the question in the Mayor's letter. Once you've done that, stick it on your fridge with the magnet where you will see it everyday!\n\nDone? Hit the Complete Button",
      onTap: () {},
    );
  }

  static Task _day7() {
    return Task.card(
      image: 'assets/images/generosity_challenge_day_7.svg',
      title: 'Giving together',
      buttonText: 'Find a charity',
      description:
          'Using your Family Values see what charities align with what you care about. Give to one of them.',
      redirect: FamilyPages.displayValues.path,
      onTap: () {},
      partnerCard: Task.card(
        image: 'assets/images/generosity_challenge_day_7.svg',
        title: 'Giving together',
        description: '',
        onTap: () {},
      ),
    );
  }

  static Task day8() {
    return Task.card(
      image: 'assets/images/generosity_challenge_day_8.svg',
      title: 'Keep the generosity alive',
      buttonText: 'Yeah sure!',
      description:
          "Let's setup a recurring giving allowance to encourage a lifelong habit of generosity.\n\nAre you ready to help them become generous individuals?",
      redirect: FamilyPages.allowanceFlow.path,
      onTap: () {},
    );
  }

  static final List<Task> _quickFlowTasks = [
    _day1(),
    _day2(),
    _day7(),
    day8(),
  ];

  static Task getTaskByIndex(int index,
      {bool isDebugQuickFlowEnabled = false}) {
    return isDebugQuickFlowEnabled ? _quickFlowTasks[index] : _tasks[index];
  }
}
