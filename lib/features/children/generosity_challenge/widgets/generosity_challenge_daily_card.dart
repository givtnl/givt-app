import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/models/task.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/features/children/generosity_challenge/pages/generosity_challenge_vpc_setup_page.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class GenerosityDailyCard extends StatelessWidget {
  const GenerosityDailyCard({
    required this.task,
    required this.isCompleted,
    this.dynamicDescription = '',
    this.isLastDay = false,
    super.key,
  });

  final Task task;
  final bool isCompleted;
  final bool isLastDay;
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
              child: SingleChildScrollView(
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
                        textAlign: TextAlign.left,
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
                                AnalyticsHelper.logEvent(
                                  eventName: AmplitudeEvents
                                      .startAssignmentFromGenerosityChallenge,
                                  eventProperties: {
                                    'title': task.title,
                                  },
                                );
                              }
                            : task.onTap,
                        isDisabled: isCompleted,
                        text: task.buttonText,
                        rightIcon: FontAwesomeIcons.arrowRight,
                      ),
                    if (isLastDay)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextButton(
                          onPressed: () {
                            // TODO integrate with add member & navigate to VPC KIDS-957
                            context.push(
                              '${Pages.generosityChallenge.path}/${task.redirect}',
                              extra: context.read<GenerosityChallengeCubit>(),
                            );
                          },
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              const GenerosityChallengeVpcSetupPage().toRoute(
                                context,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Skip',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: AppTheme.givtGreen40,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Rouna',
                                      ),
                                ),
                                const SizedBox(width: 8),
                                const FaIcon(
                                  FontAwesomeIcons.arrowRight,
                                  color: AppTheme.givtGreen40,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
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
