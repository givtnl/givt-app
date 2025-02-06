import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/models/daily_experience_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_progressbar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class DailyExperienceContainer extends StatefulWidget {
  const DailyExperienceContainer({required this.uiModel, super.key});

  final DailyExperienceUIModel uiModel;

  @override
  State<DailyExperienceContainer> createState() =>
      _DailyExperienceContainerState();
}

class _DailyExperienceContainerState extends State<DailyExperienceContainer> {
  @override
  Widget build(BuildContext context) {
    final timeLeft = widget.uiModel.timeLeft;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelLargeText.primary40(
                'Daily Goal',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.solidClock,
                    color: FamilyAppTheme.primary40,
                  ),
                  const SizedBox(width: 4),
                  LabelLargeText.primary40(
                    '${timeLeft.hour > 0 ? "${timeLeft.hour}h " : ''}${timeLeft.minute}m',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          FunProgressbar.xp(
            key: const ValueKey('Daily-Experience-Progressbar'),
            currentProgress: widget.uiModel.currentProgress,
            total: widget.uiModel.total,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
