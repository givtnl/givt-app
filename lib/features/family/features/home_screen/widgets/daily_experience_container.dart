import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_progressbar.dart';

class DailyExperienceContainer extends StatefulWidget {
  const DailyExperienceContainer({super.key});

  @override
  State<DailyExperienceContainer> createState() =>
      _DailyExperienceContainerState();
}

class _DailyExperienceContainerState extends State<DailyExperienceContainer> {
  @override
  Widget build(BuildContext context) {
    return FunProgressbar.xp(
      currentProgress: 30,
      total: 30,
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
    );
  }
}
