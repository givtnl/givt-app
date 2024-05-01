import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/widgets/family_value_container.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/widgets/values_tally.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/daily_assignment_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/family_values_content_helper.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class SelectFamilyValues extends StatelessWidget {
  const SelectFamilyValues({super.key});

  @override
  Widget build(BuildContext context) {
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
                        'Select 3 values',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppTheme.givtGreen40,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Rouna',
                            ),
                      ),
                      const ValuesTally(
                        tally: 2,
                        //state.selectedInterests.length,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ...FamilyValuesContentHelper.values.map(
              (e) => SliverPadding(
                padding: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
                sliver: SliverToBoxAdapter(
                  child: FamilyValueContainer(
                    familyValue: e,
                  ),
                ),
              ),
            ),
            // FamilyValueContainer(
            //   familyValue: FamilyValuesContentHelper.values[0],
            // ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: GivtElevatedButton(
                  onTap: () {
                    context.read<DailyAssignmentCubit>().completedFlow();
                    context.pop();
                  },
                  text: 'Continue',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
