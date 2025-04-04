import 'package:givt_app/features/family/features/recommendation/tags/models/areas.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';

sealed class SetAGoalOptions {
  SetAGoalOptions({
    required this.timesAWeek,
    required this.habitFormingLabel,
    required this.timesAWeekLabel,
    required this.weeksToFormHabit,
    required this.weeksTag,
    required this.habitFormingTag,
  });

  final int timesAWeek;
  final String habitFormingLabel;
  final String timesAWeekLabel;
  final int weeksToFormHabit;
  final Tag weeksTag;
  final Tag habitFormingTag;
}

class SetAGoalOnceAWeek extends SetAGoalOptions {
  SetAGoalOnceAWeek()
      : super(
          timesAWeek: 1,
          habitFormingLabel: 'Less strong',
          timesAWeekLabel: 'Once a week',
          weeksToFormHabit: 8,
          weeksTag: const Tag(
            key: '',
            area: Areas.lessStrong,
            displayText: '8 weeks',
            pictureUrl: '',
            type: TagType.GRATITUDEGOAL,
          ),
          habitFormingTag: const Tag(
            key: '',
            area: Areas.lessStrong,
            displayText: 'Less strong',
            subtitle: 'Habit forming',
            pictureUrl: '',
            type: TagType.GRATITUDEGOAL,
          ),
        );
}

class SetAGoalTwiceAWeek extends SetAGoalOptions {
  SetAGoalTwiceAWeek()
      : super(
          timesAWeek: 2,
          habitFormingLabel: 'Moderately strong',
          timesAWeekLabel: 'Twice a week',
          weeksToFormHabit: 6,
          weeksTag: const Tag(
            key: '',
            area: Areas.highlight,
            displayText: '6 weeks',
            pictureUrl: '',
            type: TagType.GRATITUDEGOAL,
          ),
          habitFormingTag: const Tag(
            key: '',
            area: Areas.highlight,
            displayText: 'Moderately strong',
            subtitle: 'Habit forming',
            pictureUrl: '',
            type: TagType.GRATITUDEGOAL,
          ),
        );
}

class SetAGoalThriceAWeek extends SetAGoalOptions {
  SetAGoalThriceAWeek()
      : super(
          timesAWeek: 3,
          habitFormingLabel: 'Extremely Strong',
          timesAWeekLabel: '3 times a week',
          weeksToFormHabit: 5,
          weeksTag: const Tag(
            key: '',
            area: Areas.extremelyStrong,
            displayText: '5 weeks',
            pictureUrl: '',
            type: TagType.GRATITUDEGOAL,
          ),
          habitFormingTag: const Tag(
            key: '',
            area: Areas.extremelyStrong,
            displayText: 'Extremely strong',
            subtitle: 'Habit forming',
            pictureUrl: '',
            type: TagType.GRATITUDEGOAL,
          ),
        );
}

class SetAGoalFourTimesAWeek extends SetAGoalOptions {
  SetAGoalFourTimesAWeek()
      : super(
          timesAWeek: 4,
          habitFormingLabel: 'Very strong',
          timesAWeekLabel: '4 times a week',
          weeksToFormHabit: 4,
          weeksTag: const Tag(
            key: '',
            area: Areas.strong,
            displayText: '4 weeks',
            pictureUrl: '',
            type: TagType.GRATITUDEGOAL,
          ),
          habitFormingTag: const Tag(
            key: '',
            area: Areas.strong,
            displayText: 'Very strong',
            subtitle: 'Habit forming',
            pictureUrl: '',
            type: TagType.GRATITUDEGOAL,
          ),
        );
}

class SetAGoalDaily extends SetAGoalOptions {
  SetAGoalDaily()
      : super(
          timesAWeek: 7,
          habitFormingLabel: 'Strong',
          timesAWeekLabel: 'Daily',
          weeksToFormHabit: 3,
          weeksTag: const Tag(
            key: '',
            area: Areas.primary,
            displayText: '3 weeks',
            pictureUrl: '',
            type: TagType.GRATITUDEGOAL,
          ),
          habitFormingTag: const Tag(
            key: '',
            area: Areas.primary,
            displayText: 'Strong',
            subtitle: 'Habit forming',
            pictureUrl: '',
            type: TagType.GRATITUDEGOAL,
          ),
        );
}
