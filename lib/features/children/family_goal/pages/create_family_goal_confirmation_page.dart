import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/family_goal/cubit/create_family_goal_cubit.dart';
import 'package:givt_app/features/children/family_goal/widgets/family_goal_circle.dart';
import 'package:givt_app/features/children/family_goal/widgets/family_goal_creation_stepper.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/custom_blue_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateFamilyGoalConfirmationPage extends StatelessWidget {
  const CreateFamilyGoalConfirmationPage({
    required this.state,
    super.key,
  });

  final CreateFamilyGoalState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          context.l10n.familyGoalConfirmationTitle,
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
            context.read<CreateFamilyGoalCubit>().showAmount();
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: FamilyGoalCreationStepper(
                currentStep: FamilyGoalCreationStatus.confirmation,
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
                      context.l10n.familyGoalShareWithFamily,
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
                  FamilyGoalCircle(amount: state.amount.toInt()),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.l10n.familyGoalToSupport,
                          style: GoogleFonts.mulish(
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.givtBlue,
                                ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          state.organisationName,
                          style: GoogleFonts.mulish(
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.givtBlue,
                                ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
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
                    child: CustomBlueElevatedButton(
                      title: context.l10n.familyGoalLaunch,
                      onPressed: () {
                        context
                            .read<CreateFamilyGoalCubit>()
                            .createFamilyGoal();
                        AnalyticsHelper.logEvent(
                          eventName: AmplitudeEvents.familyGoalLaunchClicked,
                          eventProperties: {
                            'charity_name': state.organisationName,
                            'amount': state.amount,
                          },
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
