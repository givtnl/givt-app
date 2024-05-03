import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/models/task.dart';
import 'package:givt_app/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class GenerosityDailyCard extends StatelessWidget {
  const GenerosityDailyCard({
    required this.task,
    required this.isCompleted,
    this.dynamicDescription = '',
    super.key,
  });

  final Task task;
  final bool isCompleted;
  final String dynamicDescription;

  @override
  Widget build(BuildContext context) {
    final bool redirect = task.redirect != null && task.redirect!.isNotEmpty;
    final description =
        dynamicDescription.isNotEmpty ? dynamicDescription : task.description;
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
                        fontSize: 20,
                        fontFamily: 'Rouna',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (description.isNotEmpty) const SizedBox(height: 8),
                  if (description.isNotEmpty)
                    Text(
                      description,
                      // if we are filling in description
                      // with user selection it is left aligned
                      // with the default description it is justified
                      textAlign: dynamicDescription.isNotEmpty
                          ? TextAlign.left
                          : TextAlign.justify,
                      style: const TextStyle(
                        color: AppTheme.givtGreen40,
                        fontSize: 18,
                        fontFamily: 'Rouna',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (task.buttonText.isNotEmpty) const SizedBox(height: 16),
                  if (task.buttonText.isNotEmpty)
                    GivtElevatedButton(
                      onTap: redirect
                          ? () {
                              context.push(
                                '${Pages.generosityChallenge.path}/${task.redirect}',
                                extra: context.read<GenerosityChallengeCubit>(),
                              );
                            }
                          : task.onTap,
                      isDisabled: isCompleted,
                      text: task.buttonText,
                      rightIcon: FontAwesomeIcons.arrowRight,
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
