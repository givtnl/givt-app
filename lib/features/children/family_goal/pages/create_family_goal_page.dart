import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/family_goal/widgets/family_goal_circle.dart';
import 'package:givt_app/features/children/family_goal/widgets/family_goal_creation_stepper.dart';
import 'package:givt_app/shared/widgets/custom_green_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateFamilyGoal extends StatelessWidget {
  const CreateFamilyGoal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          //TODO: POEditor
          'Create a Family Goal',
          style: GoogleFonts.mulish(
            textStyle: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        leading: BackButton(
          onPressed: () {
            context.pop();
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.backClicked,
            );
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FamilyGoalCreationStepper(
              currentStep: FamilyGoalCreationSteps.cause,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Text(
                //TODO: POEditor
                'Start making giving a habit in your family',
                style: GoogleFonts.mulish(
                  textStyle:
                      Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.givtBlue,
                          ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const FamilyGoalCircle(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: CustomGreenElevatedButton(
          //TODO: POEditor
          title: 'Create',
          onPressed: () {},
        ),
      ),
    );
  }
}
