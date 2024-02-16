import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class FamilyGoalCreationStepper extends StatelessWidget {
  const FamilyGoalCreationStepper({
    required this.currentStep,
    super.key,
  });

  final FamilyGoalCreationSteps currentStep;

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
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          height: 4,
                          color: currentStep.index >
                                  FamilyGoalCreationSteps.cause.index
                              ? AppTheme.givtLightGreen
                              : AppTheme.givtLightGray,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          height: 4,
                          color: currentStep.index >=
                                  FamilyGoalCreationSteps.confirmation.index
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
                              FamilyGoalCreationSteps.overview.index
                          ? AppTheme.givtLightGreen
                          : AppTheme.familyGoalStepperGray,
                    ),
                    CircleAvatar(
                      radius: 6.5,
                      backgroundColor: currentStep.index >
                              FamilyGoalCreationSteps.cause.index
                          ? AppTheme.givtLightGreen
                          : AppTheme.familyGoalStepperGray,
                    ),
                    Icon(
                      FontAwesomeIcons.flagCheckered,
                      color: currentStep.index >=
                              FamilyGoalCreationSteps.confirmation.index
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
                //TODO: POEditor
                '1. Cause',
                style: GoogleFonts.mulish(
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: currentStep.index >
                                FamilyGoalCreationSteps.overview.index
                            ? FontWeight.w800
                            : FontWeight.normal,
                        color: AppTheme.givtBlue,
                      ),
                ),
              ),
              Text(
                //TODO: POEditor
                '2. Amount',
                style: GoogleFonts.mulish(
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: currentStep.index >
                                FamilyGoalCreationSteps.cause.index
                            ? FontWeight.w800
                            : FontWeight.normal,
                        color: AppTheme.givtBlue,
                      ),
                ),
              ),
              Text(
                //TODO: POEditor
                '3. Confirm',
                style: GoogleFonts.mulish(
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: currentStep.index >=
                                FamilyGoalCreationSteps.confirmation.index
                            ? FontWeight.w800
                            : FontWeight.normal,
                        color: AppTheme.givtBlue,
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

enum FamilyGoalCreationSteps {
  overview,
  cause,
  amount,
  confirmation,
}
