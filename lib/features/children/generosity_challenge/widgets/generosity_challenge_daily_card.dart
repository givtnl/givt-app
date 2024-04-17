import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/generosity_challenge/models/task.dart';
import 'package:givt_app/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';

class GenerosityDailyCard extends StatelessWidget {
  const GenerosityDailyCard({
    required this.task,
    required this.isCompleted,
    super.key,
  });

  final Task task;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Opacity(
            opacity: isCompleted ? 0.5 : 1,
            child: Container(
              margin: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              width: double.maxFinite,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.generosityChallangeCardBorder,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
                color: AppTheme.generosityChallangeCardBackground,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (task.image.isNotEmpty)
                    SvgPicture.asset(
                      task.image,
                      height: 140,
                      width: 140,
                    ),
                  const SizedBox(height: 16),
                  if (task.title.isNotEmpty)
                    Text(
                      task.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.givtGreen40,
                        fontSize: 18,
                        fontFamily: 'Rouna',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (task.description.isNotEmpty) const SizedBox(height: 8),
                  if (task.description.isNotEmpty)
                    Text(
                      task.description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        color: AppTheme.givtGreen40,
                        fontSize: 15,
                        fontFamily: 'Rouna',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (task.buttonText.isNotEmpty) const SizedBox(height: 16),
                  if (task.buttonText.isNotEmpty)
                    GivtElevatedButton(
                      onTap: () {},
                      isDisabled: isCompleted,
                      text: task.buttonText,
                    ),
                ],
              ),
            ),
          ),
          if (isCompleted)
            const Positioned(
              right: 40,
              top: 15,
              child: Icon(
                FontAwesomeIcons.check,
                color: AppTheme.primary40,
                size: 48,
              ),
            ),
        ],
      ),
    );
  }
}
