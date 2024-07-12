import 'package:flutter/material.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/app_theme.dart';

class HowManyTasksWidget extends StatefulWidget {
  const HowManyTasksWidget({super.key});

  @override
  State<HowManyTasksWidget> createState() => _HowManyTasksWidgetState();
}

class _HowManyTasksWidgetState extends State<HowManyTasksWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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
            filled: true,
            fillColor: Colors.white,
            hintText: 'Number of tasks',
            hintStyle: textStyle?.copyWith(
              color: AppTheme.neutralVariant40,
            ),
            enabledBorder: buildInputBorder.copyWith(
              borderSide: borderSide.copyWith(
                color: AppTheme.inputFieldBorderEnabled,
              ),
            ),
            focusedBorder: buildInputBorder.copyWith(
              borderSide: borderSide.copyWith(
                color: AppTheme.inputFieldBorderEnabled,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        GivtElevatedButton(text: 'Save', onTap: () {  },
        ),
      ],
    );
  }

  TextStyle? get textStyle => Theme.of(context).textTheme.titleLarge?.copyWith(
        fontFamily: 'Rouna',
        fontWeight: FontWeight.w700,
        color: AppTheme.primary20,
      );

  BorderSide get borderSide => const BorderSide(
        color: AppTheme.inputFieldBorderSelected,
        width: 2,
      );

  InputBorder get buildInputBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: borderSide,
      );
}
