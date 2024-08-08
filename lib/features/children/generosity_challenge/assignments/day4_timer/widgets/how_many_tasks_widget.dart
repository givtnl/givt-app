import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/app_theme.dart';

class HowManyTasksWidget extends StatefulWidget {
  const HowManyTasksWidget({super.key, this.onSubmitNrOfTasks});

  final void Function(int tasks)? onSubmitNrOfTasks;

  @override
  State<HowManyTasksWidget> createState() => _HowManyTasksWidgetState();
}

class _HowManyTasksWidgetState extends State<HowManyTasksWidget> {
  late TextEditingController _controller;
  String? _errorText;

  void _logSaveClicked(int? nrOfTasks) {
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.generosityChallengeDay4SaveClicked,
        eventProperties: {
          if (nrOfTasks != null) 'nr_of_tasks': nrOfTasks,
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      if (_errorText != null) {
        setState(() {
          _errorText = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        day4TimerIconGreen(),
        const SizedBox(height: 16),
        const Text(
          'How many tasks did you complete?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.primary20,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Rouna',
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            color: AppTheme.primary20,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Rouna',
            fontFeatures: [FontFeature.tabularFigures()],
          ),
          decoration: InputDecoration(
            errorText: _errorText,
            filled: true,
            fillColor: Colors.white,
            hintText: 'Number of tasks',
            hintStyle: textStyle,
            enabledBorder: buildInputBorder,
            focusedBorder: buildInputBorder,
          ),
        ),
        const SizedBox(height: 16),
        GivtElevatedButton(
          text: 'Save',
          onTap: _handleOnTapSaved,
        ),
      ],
    );
  }

  void _handleOnTapSaved() {
    final input = _controller.text;
    int? number;
    if (input.isEmpty) {
      setState(() {
        _errorText = 'Please enter a number';
      });
    } else {
      number = int.tryParse(input.trim());
      if (number == null) {
        setState(() {
          _errorText = 'Please enter a valid number';
        });
      } else {
        widget.onSubmitNrOfTasks?.call(number);
      }
      _logSaveClicked(number);
    }
  }

  TextStyle? get textStyle => Theme.of(context).textTheme.titleLarge?.copyWith(
        fontFamily: 'Rouna',
        fontWeight: FontWeight.w700,
        color: AppTheme.neutralVariant40,
      );

  InputBorder get buildInputBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppTheme.inputFieldBorderSelected,
          width: 2,
        ),
      );
}
