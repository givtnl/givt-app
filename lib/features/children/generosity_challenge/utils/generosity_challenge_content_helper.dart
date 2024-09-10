// ignore_for_file: prefer_asserts_with_message

import 'package:givt_app/features/children/generosity_challenge/models/task.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/day5_picture_attachment_buttons.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/day_5_saved_picture.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/day_8_extra_button.dart';
import 'package:givt_app/features/family/app/family_pages.dart';

class GenerosityChallengeContentHelper {
  static final List<Task> _tasks = [
    _day1(),
    _day2(),
    const Task.card(
      image: 'assets/images/generosity_challenge_day_3.svg',
      title: 'Attention',
      description:
          'Take turns to share something you have done today or yesterday and practice giving your attention to each other.',
    ),
    Task.card(
      image: 'assets/images/generosity_challenge_day_4_green.svg',
      title: 'Time to help',
      buttonText: 'Start the timer',
      redirect: FamilyPages.day4Timer.path,
      description:
          "Look around and quickly do as many helpful tasks as you can—like feeding the dog, washing dishes, or tidying up toys. When time's up, see how many tasks you've completed.\n\nReady, set, go!",
      partnerCard: const Task.card(
        image: 'assets/images/generosity_challenge_day_4_green.svg',
        title: 'Time to help',
        description: "So many tasks done. That's a nice number!",
      ),
    ),
    const Task.card(
      image: 'assets/images/generosity_challenge_day_5.svg',
      title: 'Sharing is caring',
      description:
          "Today's assignment is for each family member to choose 1 item to give away and donate.\n\nGather all your items and take a picture of them together to show the Mayor.",
      customBottomWidget: Day5PictureAttachmentButtons(),
      partnerCard: Task.card(
        image: 'assets/images/generosity_challenge_day_5.svg',
        title: 'Sharing is caring',
        customBottomWidget: Day5SavedPicture(),
        description: '',
      ),
    ),
    const Task.card(
      image: 'assets/images/generosity_challenge_day_6.svg',
      title: 'Words of kindness',
      description:
          'Each person say one nice thing you like about someone else.\n\nFor example, "I love it when you hug me when I\'m sad."',
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
      partnerCard: const Task.card(
        image: 'assets/images/generosity_challenge_day_2.svg',
        title: 'The 3 Family Values are selected!',
        description: '',
      ),
    );
  }

  static Task _day1() {
    return const Task.card(
      image: 'assets/images/generosity_challenge_day_1.svg',
      title: 'Save the letter',
      description:
          "Today's assignment is for each family member to answer the question in the Mayor's letter. Once you've done that, stick it on your fridge with the magnet where you will see it everyday!\n\nDone? Hit the Complete Button",
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
      partnerCard: const Task.card(
        image: 'assets/images/generosity_challenge_day_7.svg',
        title: 'Giving together',
        description: '',
      ),
    );
  }

  static Task day8() {
    return Task.card(
      image: 'assets/images/generosity_challenge_day_8.svg',
      title: 'Keep the generosity alive',
      buttonText: 'Yeah sure!',
      description:
          'Add a recurring amount each month to their wallet as an easy way to build a lifelong habit of kindness.\n\nReady to help them become generous?',
      redirect: FamilyPages.allowanceFlow.path,
      customBottomWidget: const Day8ExtraButton(),
    );
  }

  static Task getTaskByIndex(int index) {
    return _tasks[index];
  }
}
