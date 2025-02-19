import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/gratitude_goal_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/models/gratitude_goal_custom.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_progressbar.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_medium_text.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';

class GratitudeGoalContainer extends StatefulWidget {
  const GratitudeGoalContainer({super.key});

  @override
  State<GratitudeGoalContainer> createState() =>
      _GratitudeGoalContainerState();
}

class _GratitudeGoalContainerState extends State<GratitudeGoalContainer> {
  final GratitudeGoalCubit _cubit = getIt<GratitudeGoalCubit>();

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
                    'Play ${uiModel.gratitudeGoal}x Weekly',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FunIcon.clock(),
                      const SizedBox(width: 4),
                      if (_timer != null)
                        LabelMediumText.primary40(
                          _remainingHours > 48
                              ? '${_remainingHours ~/ 24} days left'
                              : _remainingHours > 0
                                  ? '${_remainingHours}h ${_remainingMinutes}m'
                                  : '${_remainingMinutes}m',
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FunProgressbar.gratitudeGoal(
                key: const ValueKey('Daily-Experience-Progressbar'),
                currentProgress: uiModel.gratitudeGoalCurrent,
                total: uiModel.gratitudeGoal,
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void onCustom(BuildContext context, GratitudeGoalCustom state) {
    switch (state) {
      case final StartCounter event:
        _startCountdown(event.countdownTo);
    }
  }
}
