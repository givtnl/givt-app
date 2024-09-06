// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/bloc/interview_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/pass_the_phone_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/record_timer.dart';
import 'package:givt_app/features/family/helpers/vibrator.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/app_theme.dart';

class RecordAnswerScreen extends StatefulWidget {
  RecordAnswerScreen({required this.reporters, super.key});

  final List<GameProfile> reporters;

  @override
  State<RecordAnswerScreen> createState() => _RecordAnswerScreenState();
}

class _RecordAnswerScreenState extends State<RecordAnswerScreen> {
  _RecordAnswerScreenState({int startSeconds = 60 * 2})
      : _remainingSeconds = startSeconds;
  Timer? _timer;
  int _remainingSeconds;
  int _currentQuestionIndex = 0; // Track the current question index globally
  int _currentReporterIndex = 0; // Track the current reporter index
  String buttontext = 'Start Interview';
  InterviewCubit cubit = getIt<InterviewCubit>();
  AppConfig config = getIt<AppConfig>();
  bool isTestBtnVisible = false;

  late GameProfile _currentReporter;
  late GameProfile _currentSidekick;

  @override
  void initState() {
    super.initState();
    _currentReporter = widget.reporters[_currentReporterIndex];
    _currentSidekick = cubit.getSidecick();
    isTestBtnVisible = config.isTestApp;
  }

  String _displayMinutes() => (_remainingSeconds ~/ 60).toString();

  String _displaySeconds() {
    final displaySeconds = _remainingSeconds % 60;
    return displaySeconds < 10 ? '0$displaySeconds' : displaySeconds.toString();
  }

  bool _isLastTenSeconds() =>
      _lessThanAMinuteLeft() &&
      _remainingSeconds % 60 <= 10 &&
      _remainingSeconds % 60 > 1;

  bool _lessThanAMinuteLeft() => _remainingSeconds ~/ 60 == 0;

  bool _isLastSecond() => _remainingSeconds % 60 <= 1 && _remainingSeconds <= 1;

  void _startCountdown() {
    setState(() {
      buttontext = 'Next reporter';
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
      } else {
        _handleEffects();
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _handleEffects() {
    if (_isLastTenSeconds()) {
      Vibrator.tryVibrate();
    } else if (_isLastSecond()) {
      // Do nothing for now
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _allQuestionsAsked() {
    // Check if all reporters have no more questions
    return widget.reporters.every((reporter) {
      final reporterQuestions = (reporter.role! as Reporter).questions!;
      return _currentQuestionIndex >= reporterQuestions.length;
    });
  }

  bool _nextQuestionIsLast() {
    return widget.reporters.every((reporter) {
      final reporterQuestions = (reporter.role! as Reporter).questions!;
      return _currentQuestionIndex + 1 >= reporterQuestions.length;
    });
  }

  void _advanceToNextReporter() {
    setState(() {
      _currentReporterIndex++;
      if (_currentReporterIndex >= widget.reporters.length) {
        // All reporters have asked their question at this index
        _currentReporterIndex = 0;
        _currentQuestionIndex++;

        if (_allQuestionsAsked()) {
          // Move to sidekick screen or end
          Navigator.of(context).push(
            PassThePhone.toSidekick(_currentSidekick).toRoute(context),
          );
          return;
        }
      }

      if (_nextQuestionIsLast()) {
        buttontext = 'Finish';
      }

      // Update the current reporter
      _currentReporter = widget.reporters[_currentReporterIndex];
      //_remainingSeconds = 60 * 2; // Reset the timer
    });
  }

  @override
  Widget build(BuildContext context) {
    final reporterQuestions = (_currentReporter.role! as Reporter).questions!;
    final hasQuestion = _currentQuestionIndex <
        reporterQuestions
            .length; // Check if reporter has a question at current index

    return FunScaffold(
      canPop: false,
      appBar: FunTopAppBar.primary99(
        title: _currentReporter.firstName!,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SvgPicture.network(
              _currentReporter.pictureURL!,
              width: 36,
              height: 36,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: hasQuestion
                ? TitleMediumText(
                    reporterQuestions[_currentQuestionIndex],
                    textAlign: TextAlign.center,
                  )
                : TitleMediumText(
                    '${_currentReporter.firstName!} has no more questions.',
                    textAlign: TextAlign.center,
                  ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.generosityChallangeCardBorder,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
              color: AppTheme.generosityChallangeCardBackground,
            ),
            child: Column(
              children: [
                const SizedBox(height: 16),
                RecordTimerWidget(
                  seconds: _displaySeconds(),
                  minutes: _displayMinutes(),
                  showRedVersion: _isLastTenSeconds(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FunButton(
                    rightIcon: FontAwesomeIcons.arrowRight,
                    onTap: () {
                      if (_remainingSeconds == 60 * 2) {
                        _startCountdown();
                        setState(() {
                          isTestBtnVisible = false;
                        });
                        return;
                      }
                      _advanceToNextReporter();
                    },
                    text: buttontext,
                  ),
                ),
                Visibility(
                    visible: isTestBtnVisible,
                    child: const SizedBox(height: 8)),
                Visibility(
                  visible: isTestBtnVisible,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: FunButton(
                        isTertiary: true,
                        onTap: () {
                          if (_remainingSeconds == 60 * 2) {
                            _startCountdown();
                            setState(() {
                              _remainingSeconds = 20;
                              isTestBtnVisible = false;
                            });
                            return;
                          }
                          _advanceToNextReporter();
                        },
                        text: 'Start test 20 seconds'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
