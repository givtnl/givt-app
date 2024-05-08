import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/cubit/family_values_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/widgets/family_value_container.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/widgets/values_tally.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/family_values_content_helper.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class SelectFamilyValues extends StatelessWidget {
  const SelectFamilyValues({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FamilyValuesCubit, FamilyValuesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: GenerosityAppBar(
            title: 'Day 2',
            leading: BackButton(
              onPressed: context.pop,
              color: AppTheme.givtGreen40,
            ),
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  sliver: SliverAppBar(
                    pinned: true,
                    primary: false,
                    backgroundColor: Colors.white,
                    surfaceTintColor: AppTheme.primary90,
                    automaticallyImplyLeading: false,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select ${FamilyValuesState.maxSelectedValues} values',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppTheme.givtGreen40,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Rouna',
                                ),
                          ),
                          ValuesTally(
                            tally: state.selectedValues.length,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ...FamilyValuesContentHelper.values.map(
                  (e) => SliverPadding(
                    padding:
                        const EdgeInsets.only(bottom: 16, left: 24, right: 24),
                    sliver: SliverToBoxAdapter(
                      child: FamilyValueContainer(
                        familyValue: e,
                        isSelected: state.selectedValues.contains(e),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: state.selectedValues.length !=
                  FamilyValuesState.maxSelectedValues
              ? const SizedBox()
              : GivtElevatedButton(
                  onTap: () {
                    context.read<FamilyValuesCubit>().rememberValues();

                    context.read<GenerosityChallengeCubit>().confirmAssignment(
                          state.selectedValuesString,
                        );

                    context.pop();

                    AnalyticsHelper.logEvent(
                      eventName: AmplitudeEvents.familyValuesSelected,
                      eventProperties: {
                        FamilyValuesCubit.familyValuesKey:
                            state.selectedValuesString,
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
