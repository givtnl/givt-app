sealed class BehaviorOptions {
  BehaviorOptions({
    required this.weWillBeMoreLabel,
    required this.behavior,
    required this.weWantToBeLabel,
    required this.captainExplanation,
  });

  final String weWillBeMoreLabel;
  final String behavior;
  final String weWantToBeLabel;
  final String captainExplanation;
}

class SayingThankYou extends BehaviorOptions {
  SayingThankYou()
      : super(
          weWillBeMoreLabel: 'We will be more thankful',
          behavior: 'Saying thank you',
          weWantToBeLabel: 'We want to be more thankful, so we will...',
    captainExplanation:
              'Science shows a daily practice of gratitude helps your family to become more thankful',
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
        );
}
