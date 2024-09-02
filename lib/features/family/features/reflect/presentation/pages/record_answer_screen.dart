// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/record_timer.dart';
import 'package:givt_app/features/family/helpers/vibrator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/family_scaffold.dart';
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
  GameProfile? _currentReporter;
  String buttontext = 'Start Recording';
  @override
  void initState() {
    super.initState();
    _currentReporter = widget.reporters.first;
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
      buttontext = 'Next journalist';
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
      //    Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FamilyScaffold(
      appBar: GenerosityAppBar(
        title: _currentReporter!.firstName!,
        leading: null,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SvgPicture.network(
              _currentReporter!.pictureURL!,
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
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: TitleMediumText(
              (_currentReporter!.role! as Reporter).questions!.first,
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
                // record button
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: GivtElevatedButton(
                    isDisabled: widget.reporters.length == 0,
                    rightIcon: FontAwesomeIcons.arrowRight,
                    onTap: () {
                      if (_remainingSeconds == 60 * 2) {
                        _startCountdown();
                        setState(() {
                          _remainingSeconds = 20;
                        });
                        return;
                      }
                      if (_remainingSeconds != 60 * 2 &&
                          widget.reporters.length > 1) {
                        setState(() {
                          _currentReporter = widget.reporters[1];
                          widget.reporters.removeAt(0);
                          buttontext = widget.reporters.length == 1
                              ? 'Finish'
                              : 'Next journalist';
                        });
                      }
                    },
                    text: buttontext,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
