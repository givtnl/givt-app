import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/family_goal/cubit/create_family_goal_cubit.dart';
import 'package:givt_app/features/children/family_goal/widgets/family_goal_circle.dart';
import 'package:givt_app/features/children/family_goal/widgets/family_goal_creation_stepper.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateFamilyGoalOverviewPage extends StatelessWidget {
  const CreateFamilyGoalOverviewPage({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          context.l10n.familyGoalOverviewTitle,
          style: GoogleFonts.mulish(
            textStyle: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        leading: BackButton(
          color: AppTheme.givtBlue,
          onPressed: () {
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.backClicked,
            );

            context.pop();
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: FamilyGoalCreationStepper(
                currentStep: FamilyGoalCreationStatus.overview,
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Text(
                      context.l10n.familyGoalStartMakingHabit,
                      style: GoogleFonts.mulish(
                        textStyle:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
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
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 24,
                      right: 24,
                      bottom: 16,
                    ),
                    child: CustomGreenElevatedButton(
                      title: context.l10n.familyGoalCreate,
                      onPressed: () {
                        context.read<CreateFamilyGoalCubit>().showCause();
                        AnalyticsHelper.logEvent(
                          eventName: AmplitudeEvents.familyGoalCreateClicked,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
