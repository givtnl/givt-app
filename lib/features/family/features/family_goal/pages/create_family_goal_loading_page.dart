import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/family_goal/cubit/create_family_goal_cubit.dart';
import 'package:givt_app/features/family/features/family_goal/widgets/family_goal_creation_stepper.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateFamilyGoalLoadingPage extends StatelessWidget {
  const CreateFamilyGoalLoadingPage({
    required this.stepperStatus,
    super.key,
  });

  final FamilyGoalCreationStatus stepperStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          stepperStatus == FamilyGoalCreationStatus.overview
              ? context.l10n.familyGoalOverviewTitle
              : context.l10n.familyGoalConfirmationTitle,
          style: GoogleFonts.mulish(
            textStyle: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FamilyGoalCreationStepper(currentStep: stepperStatus),
            const Expanded(
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
          ],
        ),
      ),
    );
  }
}
