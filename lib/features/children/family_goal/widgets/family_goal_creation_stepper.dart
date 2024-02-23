import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/children/family_goal/cubit/create_family_goal_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class FamilyGoalCreationStepper extends StatelessWidget {
  const FamilyGoalCreationStepper({
    required this.currentStep,
    super.key,
  });

  final FamilyGoalCreationStatus currentStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Stack(
              children: [
                Positioned.fill(
                  left: 3,
                  right: 3,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          height: 4,
                          color: currentStep.index >
                                  FamilyGoalCreationStatus.cause.index
                              ? AppTheme.givtLightGreen
                              : AppTheme.givtLightGray,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          height: 4,
                          color: currentStep.index >=
                                  FamilyGoalCreationStatus.confirmation.index
                              ? AppTheme.givtLightGreen
                              : AppTheme.givtLightGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 6.5,
                      backgroundColor: currentStep.index >
                              FamilyGoalCreationStatus.overview.index
                          ? AppTheme.givtLightGreen
                          : AppTheme.familyGoalStepperGray,
                    ),
                    CircleAvatar(
                      radius: 6.5,
                      backgroundColor: currentStep.index >
                              FamilyGoalCreationStatus.cause.index
                          ? AppTheme.givtLightGreen
                          : AppTheme.familyGoalStepperGray,
                    ),
                    //temporary solution with svgs
                    //let's replace with fontawesomeicons (pro) when possible
                    SvgPicture.asset(
                      'assets/images/stepper_flag.svg',
                      height: 22,
                      color: currentStep.index >=
                              FamilyGoalCreationStatus.confirmation.index
                          ? AppTheme.givtLightGreen
                          : AppTheme.familyGoalStepperGray,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.familyGoalStepperCause,
                style: GoogleFonts.mulish(
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight:
                            currentStep == FamilyGoalCreationStatus.cause
                                ? FontWeight.w800
                                : FontWeight.w400,
                        color: currentStep == FamilyGoalCreationStatus.cause
                            ? AppTheme.givtBlue
                            : AppTheme.familyGoalStepperGray,
                      ),
                ),
              ),
              Text(
                context.l10n.familyGoalStepperAmount,
                style: GoogleFonts.mulish(
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight:
                            currentStep == FamilyGoalCreationStatus.amount
                                ? FontWeight.w800
                                : FontWeight.w400,
                        color: currentStep == FamilyGoalCreationStatus.amount
                            ? AppTheme.givtBlue
                            : AppTheme.familyGoalStepperGray,
                      ),
                ),
              ),
              Text(
                context.l10n.familyGoalStepperConfirm,
                style: GoogleFonts.mulish(
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: currentStep.index >=
                                FamilyGoalCreationStatus.confirmation.index
                            ? FontWeight.w800
                            : FontWeight.w400,
                        color: currentStep.index >=
                                FamilyGoalCreationStatus.confirmation.index
                            ? AppTheme.givtBlue
                            : AppTheme.familyGoalStepperGray,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
