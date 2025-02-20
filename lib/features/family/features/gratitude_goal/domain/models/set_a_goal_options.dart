sealed class SetAGoalOptions {
  SetAGoalOptions({
    required this.timesAWeek,
    required this.habitFormingLabel,
    required this.timesAWeekLabel,
    required this.weeksToFormHabit,
  });

  final int timesAWeek;
  final String habitFormingLabel;
  final String timesAWeekLabel;
  final int weeksToFormHabit;
}

class SetAGoalOnceAWeek extends SetAGoalOptions {
  SetAGoalOnceAWeek()
      : super(
          timesAWeek: 1,
          habitFormingLabel: 'Less strong',
          timesAWeekLabel: 'Once a week',
          weeksToFormHabit: 8,
        );
}

class SetAGoalTwiceAWeek extends SetAGoalOptions {
  SetAGoalTwiceAWeek()
      : super(
          timesAWeek: 2,
          habitFormingLabel: 'Moderately strong',
          timesAWeekLabel: 'Twice a week',
          weeksToFormHabit: 6,
        );
}

class SetAGoalThriceAWeek extends SetAGoalOptions {
  SetAGoalThriceAWeek()
      : super(
          timesAWeek: 3,
          habitFormingLabel: 'Strong',
          timesAWeekLabel: '3 times a week',
          weeksToFormHabit: 5,
        );
}

class SetAGoalFourTimesAWeek extends SetAGoalOptions {
  SetAGoalFourTimesAWeek()
      : super(
          timesAWeek: 4,
          habitFormingLabel: 'Very strong',
          timesAWeekLabel: '4 times a week',
          weeksToFormHabit: 4,
        );
}

class SetAGoalDaily extends SetAGoalOptions {
  SetAGoalDaily()
      : super(
          timesAWeek: 7,
          habitFormingLabel: 'Extremely strong',
          timesAWeekLabel: 'Daily',
          weeksToFormHabit: 3,
        );
}
