import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/family_goal/widgets/family_goal_circle.dart';
import 'package:givt_app/features/children/family_goal/widgets/family_goal_creation_stepper.dart';
import 'package:givt_app/shared/widgets/custom_green_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

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
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w800,
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
              currentStep: FamilyGoalCreationSteps.overview,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Text(
                //TODO: POEditor
                'Start making giving a habit in your family',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w700,
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
