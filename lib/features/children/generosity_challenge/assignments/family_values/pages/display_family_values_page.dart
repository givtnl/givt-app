import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/cubit/family_values_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/widgets/family_value_container.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/widgets/family_values_sliver_app_bar.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class DisplayFamilyValues extends StatelessWidget {
  const DisplayFamilyValues({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FamilyValuesCubit, FamilyValuesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const GenerosityAppBar(
            title: 'Day 7',
            leading: GenerosityBackButton(),
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                FamilyValuesSliverAppBar(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'Your Family Values',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.givtGreen40,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Rouna',
                                ),
                      ),
                    ),
                  ),
                ),
                ...state.selectedValues.map(
                  (e) => SliverPadding(
                    padding:
                        const EdgeInsets.only(bottom: 16, left: 24, right: 24),
                    sliver: SliverToBoxAdapter(
                      child: FamilyValueContainer(
                        familyValue: e,
                        isSelected: false,
                        isPressed: true,
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          ),
          floatingActionButton: FunButton(
            onTap: () {
              AnalyticsHelper.logEvent(
                eventName:
                    AmplitudeEvents.daySevenFamilyValuesSeenContinueClicked,
              );
              context.pushNamed(
                FamilyPages.displayValuesOrganisations.name,
                extra: {
                  FamilyValuesCubit.familyValuesKey: state.selectedValues,
                  GenerosityChallengeHelper.generosityChallengeKey:
                      context.read<GenerosityChallengeCubit>(),
                },
              );
            },
            text: 'Continue',
          ),
        );
      },
    );
  }
}
