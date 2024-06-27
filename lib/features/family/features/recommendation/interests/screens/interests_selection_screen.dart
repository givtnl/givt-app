import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/recommendation/interests/cubit/interests_cubit.dart';
import 'package:givt_app/features/family/features/recommendation/interests/widgets/interest_card.dart';
import 'package:givt_app/features/family/features/recommendation/interests/widgets/interests_tally.dart';
import 'package:givt_app/features/family/features/recommendation/widgets/charity_finder_app_bar.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class InterestsSelectionScreen extends StatelessWidget {
  const InterestsSelectionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InterestsCubit, InterestsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const CharityFinderAppBar(),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(top: 16),
                  sliver: SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.white,
                    surfaceTintColor: AppTheme.primary90,
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select your top 3 choices',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        InterestsTally(
                          tally: state.selectedInterests.length,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: LayoutGrid(
                      // set some flexible track sizes based on the crossAxisCount
                      columnSizes: [1.fr, 1.fr],
                      // set all the row sizes to auto (self-sizing height)
                      rowSizes: [
                        for (int i = 0;
                            i < (state.interests.length / 2).ceil();
                            i++)
                          auto,
                      ],
                      columnGap: 16,
                      rowGap: 16,
                      children: [
                        for (int i = 0; i < state.interests.length; i++)
                          InterestCard(
                            interest: state.interests[i],
                            isSelected: state.selectedInterests
                                .contains(state.interests[i]),
                            onPressed: () {
                              context
                                  .read<InterestsCubit>()
                                  .selectInterest(state.interests[i]);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Visibility(
            visible:
                state.selectedInterests.length == InterestsState.maxInterests,
            child: GivtElevatedButton(
              isDisabled:
                  state.selectedInterests.length != InterestsState.maxInterests,
              text: 'Next',
              onTap: state.selectedInterests.length ==
                      InterestsState.maxInterests
                  ? () {
                      context.pushNamed(
                        FamilyPages.recommendedOrganisations.name,
                        extra: state,
                      );
                      context.read<InterestsCubit>().clearSelectedInterests();
                    }
                  : null,
            ),
          ),
        );
      },
    );
  }
}
