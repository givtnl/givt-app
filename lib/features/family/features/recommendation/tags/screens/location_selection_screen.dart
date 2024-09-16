import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/recommendation/tags/cubit/tags_cubit.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';
import 'package:givt_app/features/family/features/recommendation/tags/widgets/city_card.dart';
import 'package:givt_app/features/family/features/recommendation/tags/widgets/location_card.dart';
import 'package:givt_app/features/family/features/recommendation/widgets/charity_finder_app_bar.dart';
import 'package:givt_app/features/family/helpers/svg_manager.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class LocationSelectionScreen extends StatelessWidget {
  const LocationSelectionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagsCubit, TagsState>(
      builder: (context, state) {
        final svgManager = getIt<SvgAssetLoaderManager>();
        final isCitySelection = state.status == LocationSelectionStatus.city;
        return FunScaffold(
          appBar: const CharityFinderAppBar(),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                forceMaterialTransparency: true,
                automaticallyImplyLeading: false,
                title: TitleMediumText(
                  state is TagsStateFetching
                      ? 'Give me a moment to think'
                      : isCitySelection
                          ? 'Which City?'
                          : 'Where do you want to help?',
                  textAlign: TextAlign.center,
                ),
              ),
              if (state is TagsStateFetched)
                isCitySelection
                    ? SliverToBoxAdapter(
                        child: LayoutGrid(
                          // set some flexible track sizes based on the crossAxisCount
                          columnSizes: [1.fr, 1.fr],
                          // set all the row sizes to auto (self-sizing height)
                          rowSizes: const [auto, auto],
                          columnGap: 16,
                          rowGap: 16,
                          children: state.hardcodedCities
                              .map(
                                (city) => CityCard(
                                  cityName: city['cityName']!,
                                  stateName: city['stateName']!,
                                  isSelected:
                                      city['cityName'] == state.selectedCity,
                                  onPressed: () {
                                    context.read<TagsCubit>().selectCity(city);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: LayoutGrid(
                          // set some flexible track sizes based on the crossAxisCount
                          columnSizes: [1.fr, 1.fr],
                          // set all the row sizes to auto (self-sizing height)
                          rowSizes: [
                            for (int i = 0;
                                i < (state.locations.length / 2).ceil();
                                i++)
                              auto,
                          ],
                          columnGap: 16,
                          rowGap: 16,
                          children: state.locations.reversed
                              .map(
                                (location) => LocationCard(
                                  location: location,
                                  isSelected:
                                      location == state.selectedLocation,
                                  onPressed: () {
                                    context
                                        .read<TagsCubit>()
                                        .selectLocation(location: location);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: state is! TagsStateFetching
                    ? Column(
                        children: [
                          const Spacer(),
                          FunButton(
                            isDisabled: state is TagsStateFetched &&
                                    state.selectedLocation != const Tag.empty()
                                ? isCitySelection && state.selectedCity.isEmpty
                                : true,
                            text: 'Next',
                            onTap: state is TagsStateFetched &&
                                    state.selectedLocation != const Tag.empty()
                                ? () {
                                    if (state.selectedLocation.key == 'STATE' &&
                                        state.status ==
                                            LocationSelectionStatus.general) {
                                      context
                                          .read<TagsCubit>()
                                          .goToCitySelection();
                                      return;
                                    }
                                    svgManager.preloadSvgAssets(
                                      state.interests
                                          .map((e) => e.pictureUrl)
                                          .toList(),
                                    );
                                    context.pushNamed(
                                      FamilyPages.interestsSelection.name,
                                      extra: state,
                                    );
                                  }
                                : null,
                            analyticsEvent: AnalyticsEvent(
                              AmplitudeEvents.locationSelected,
                              parameters: {
                                'location': state.selectedLocation.displayText,
                              },
                            ),
                          ),
                        ],
                      )
                    : null,
              )
            ],
          ),
        );
      },
    );
  }
}
