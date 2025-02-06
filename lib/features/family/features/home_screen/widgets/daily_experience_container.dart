import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/daily_experience_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/models/daily_experience_custom.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_progressbar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';

class DailyExperienceContainer extends StatefulWidget {
  const DailyExperienceContainer({super.key});

  @override
  State<DailyExperienceContainer> createState() =>
      _DailyExperienceContainerState();
}

class _DailyExperienceContainerState extends State<DailyExperienceContainer> {
  final DailyExperienceCubit _cubit = getIt<DailyExperienceCubit>();

  Timer? _timer;
  late int _minutesUntilReset;

  @override
  void initState() {
    super.initState();
    _cubit.init();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cubit.close();
    super.dispose();
  }

  void _startCountdown(DateTime timeOfReset) {
    _timer?.cancel();
    _minutesUntilReset = timeOfReset.difference(DateTime.now()).inMinutes;
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      if (_minutesUntilReset <= 0) {
        timer.cancel();
      } else {
        if (!mounted) return;
        setState(() {
          _minutesUntilReset--;
        });
      }
    });
  }

  int get _remainingMinutes {
    return _minutesUntilReset % 60;
  }

  int get _remainingHours {
    return _minutesUntilReset ~/ 60;
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onCustom: onCustom,
      onLoading: (context) => const SizedBox.shrink(),
      onError: (context, error) => const SizedBox.shrink(),
      onData: (context, uiModel) {
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
                      if (_timer != null)
                        LabelLargeText.primary40(
                          '${_remainingHours > 0 ? "${_remainingHours}h " : ''}${_remainingMinutes}m',
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FunProgressbar.xp(
                key: const ValueKey('Daily-Experience-Progressbar'),
                currentProgress: uiModel.currentProgress,
                total: uiModel.total,
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void onCustom(BuildContext context, DailyExperienceCustom state) {
    switch (state) {
      case final StartCounter event:
        _startCountdown(event.countdownTo);
    }
  }
}
