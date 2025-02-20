sealed class BehaviorOptions {
  BehaviorOptions({
    required this.weWillBeMoreLabel,
    required this.behavior,
    required this.weWantToBeLabel,
    required this.captainExplanation,
    required this.index,
  });

  final String weWillBeMoreLabel;
  final String behavior;
  final String weWantToBeLabel;
  final String captainExplanation;
  final int index;
}

class SayingThankYou extends BehaviorOptions {
  SayingThankYou()
      : super(
          weWillBeMoreLabel: 'We will be more thankful',
          behavior: 'Saying thank you',
          weWantToBeLabel: 'We want to be more thankful, so we will...',
          captainExplanation:
              'Science shows a daily practice of gratitude helps your family to become more thankful',
          index: 0,
        );
}

class HavingAppreciation extends BehaviorOptions {
  HavingAppreciation()
      : super(
          weWillBeMoreLabel: 'We will be more appreciative',
          behavior: 'Having appreciation',
          weWantToBeLabel: 'We want to be more appreciative, so we will...',
          captainExplanation:
              'Science shows a daily practice of gratitude helps your family to become more appreciative',
          index: 1,
        );
}

class DealingWithEmotions extends BehaviorOptions {
  DealingWithEmotions()
      : super(
          weWillBeMoreLabel: 'We will deal better with emotions',
          behavior: 'Dealing with emotions',
          weWantToBeLabel:
              'We want to deal better with emotions, so we will...',
          captainExplanation:
              'Science shows a daily practice of gratitude helps your family to better deal with emotions',
          index: 2,
        );
}

class WorkingTogether extends BehaviorOptions {
  WorkingTogether()
      : super(
          weWillBeMoreLabel: 'We will be more collaborative',
          behavior: 'Working together',
          weWantToBeLabel: 'We want to be more collaborative, so we will...',
          captainExplanation:
              'Science shows a daily practice of gratitude helps your family to learn to collaborate more',
          index: 3,
        );
}
