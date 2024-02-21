import 'package:flutter/material.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/family_goal/cubit/create_family_goal_cubit.dart';
import 'package:givt_app/features/children/family_goal/widgets/family_goal_circle.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CreateFamilyGoalConfirmedPage extends StatelessWidget {
  const CreateFamilyGoalConfirmedPage({
    required this.state,
    super.key,
  });

  final CreateFamilyGoalState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          CloseButton(
            color: AppTheme.givtBlue,
            onPressed: () {
              context
                ..pop()
                ..pushReplacementNamed(Pages.childrenOverview.name);

              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.familyGoalLaunchedCloseClicked,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 79),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 30,
                    ),
                    child: Text(
                      context.l10n.familyGoalConfirmedTitle,
                      style: GoogleFonts.mulish(
                        textStyle:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.givtBlue,
                                ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FamilyGoalCircle(amount: state.amount.toInt()),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 24, right: 24, top: 10),
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
                        const SizedBox(height: 10),
                        Text(
                          state.organisationName,
                          style: GoogleFonts.mulish(
                            textStyle: Theme.of(context)
                                .textTheme
                                .headlineSmall
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
            Positioned.fill(
              child: Lottie.asset(
                'assets/lotties/confetti.json',
                fit: BoxFit.fitWidth,
                // repeat: false,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
