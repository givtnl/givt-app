part of 'level_select_cubit.dart';

sealed class LevelSelectCustom {
  const LevelSelectCustom();
}

class NavigateToLevelIntroduction extends LevelSelectCustom {
  final int level;
  const NavigateToLevelIntroduction(this.level);
} 