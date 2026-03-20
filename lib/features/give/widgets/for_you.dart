import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_tile.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_input.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/cubit/for_you_goals_cubit.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

const _otherWayLocationImage = 'assets/images/for_you/location_based.png';
const _otherWayQrImage = 'assets/images/for_you/givt_qr.png';
const _otherWayBeaconImage = 'assets/images/for_you/collection_device.png';

class ForYou extends StatefulWidget {
  const ForYou({
    super.key,
  });

  @override
  State<ForYou> createState() => _ForYouState();
}

class _ForYouState extends State<ForYou>
    with AutomaticKeepAliveClientMixin<ForYou> {
  late final ForYouGoalsCubit _goalsCubit;
  late final PageController _favoritesController;
  int _favoritesIndex = 0;

  static const double _sidePadding = 8;

  @override
  void initState() {
    super.initState();
    _goalsCubit = ForYouGoalsCubit(getIt(), getIt());
    _favoritesController = PageController(viewportFraction: 0.92);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _goalsCubit.close();
    _favoritesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final locals = context.l10n;
    return BlocListener<OrganisationBloc, OrganisationState>(
      listenWhen: (previous, current) =>
          previous.favoritedOrganisations != current.favoritedOrganisations ||
          previous.filteredOrganisations != current.filteredOrganisations,
      listener: (context, state) {
        final favoriteIds = state.favoritedOrganisations
            .where(
              (id) =>
                  state.filteredOrganisations.any((org) => org.nameSpace == id),
            )
            .toList();
        _goalsCubit.loadForFavorites(favoriteIds);
      },
      child: BlocBuilder<OrganisationBloc, OrganisationState>(
        builder: (context, state) {
          final favoriteOrganisations = state.filteredOrganisations
              .where(
                (org) => state.favoritedOrganisations.contains(org.nameSpace),
              )
              .toList();
          return BlocBuilder<ForYouGoalsCubit, ForYouGoalsState>(
            bloc: _goalsCubit,
            builder: (context, goalsState) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _sidePadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      if (favoriteOrganisations.isEmpty)
                        _buildEmptyState(context)
                      else ...[
                        _buildFavoritesCarousel(
                          context,
                          favoriteOrganisations,
                          goalsState,
                        ),
                        const SizedBox(height: 12),
                        _buildPageIndicators(
                          context,
                          count: favoriteOrganisations.length,
                          current: _favoritesIndex,
                        ),
                      ],
                      const SizedBox(height: 24),
                      TitleMediumText(
                        locals.forYouOtherWaysToGive,
                        color: FunTheme.of(context).secondary20,
                      ),
                      const SizedBox(height: 16),
                      _buildSearchRow(
                        context,
                        title: locals.forYouSearchOrganizations,
                        analyticsEvent: AnalyticsEvent(
                          AmplitudeEvents.forYouSearchTapped,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // Layout: 2 full tiles + a peek of the 3rd.
                          const gap = 12.0;
                          const thirdPeek = 32.0;
                          final tileWidth =
                              (constraints.maxWidth - gap - thirdPeek) / 2;

                          // IntrinsicHeight: grow with content, then
                          // stretch all 3 tiles to the tallest one.
                          return IntrinsicHeight(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              clipBehavior: Clip.none,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    width: tileWidth,
                                    child: _buildOtherWayTile(
                                      context,
                                      title: locals.forYouLocationBasedTitle,
                                      subtitle:
                                          locals.forYouLocationBasedSubtitle,
                                      imageUrl: _otherWayLocationImage,
                                      variant: FunTileVariant.two,
                                      analyticsEvent: AnalyticsEvent(
                                        AmplitudeEvents
                                            .forYouOtherWaysLocationTapped,
                                      ),
                                      onTap: () =>
                                          _openForYouDiscovery(
                                        ForYouEntrySource.location,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: gap),
                                  SizedBox(
                                    width: tileWidth,
                                    child: _buildOtherWayTile(
                                      context,
                                      title: locals.forYouQrCodeTitle,
                                      subtitle: locals.forYouQrCodeSubtitle,
                                      imageUrl: _otherWayQrImage,
                                      variant: FunTileVariant.one,
                                      analyticsEvent: AnalyticsEvent(
                                        AmplitudeEvents.forYouOtherWaysQrTapped,
                                      ),
                                      onTap: () => _openForYouDiscovery(
                                        ForYouEntrySource.qrCode,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: gap),
                                  SizedBox(
                                    width: tileWidth,
                                    child: _buildOtherWayTile(
                                      context,
                                      title: locals.forYouCollectionDeviceTitle,
                                      subtitle:
                                          locals.forYouCollectionDeviceSubtitle,
                                      imageUrl: _otherWayBeaconImage,
                                      variant: FunTileVariant.three,
                                      analyticsEvent: AnalyticsEvent(
                                        AmplitudeEvents
                                            .forYouOtherWaysBeaconTapped,
                                      ),
                                      onTap: () => _openForYouDiscovery(
                                        ForYouEntrySource.collectionDevice,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final locals = context.l10n;

    return FunMissionCard(
      uiModel: FunMissionCardUIModel(
        headerIcon: FunIcon.heart(),
        title: locals.forYouEmptyFavoritesTitle,
        description: locals.forYouEmptyFavoritesBody,
      ),
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.forYouSearchTapped,
      ),
      onTap: () => _openForYouList(ForYouEntrySource.emptyState),
    );
  }

  Widget _buildFavoritesCarousel(
    BuildContext context,
    List<CollectGroup> favoriteOrganisations,
    ForYouGoalsState goalsState,
  ) {
    return Stack(
      children: [
        // Invisible card to define the height of the Stack based on its content
        if (favoriteOrganisations.isNotEmpty)
          Opacity(
            opacity: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: _buildFavoriteCard(
                context,
                organisation: favoriteOrganisations.first,
                goalsState: goalsState,
                showCounts: true,
              ),
            ),
          ),
        Positioned.fill(
          child: PageView.builder(
            clipBehavior: Clip.none,
            padEnds: false,
            controller: _favoritesController,
            onPageChanged: (index) => setState(() => _favoritesIndex = index),
            itemCount: favoriteOrganisations.length,
            itemBuilder: (context, index) {
              final organisation = favoriteOrganisations[index];
              final summary =
                  goalsState.summariesByCollectGroupId[organisation.nameSpace];
              final showCounts = !goalsState.isOffline && summary != null;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _buildFavoriteCard(
                  context,
                  organisation: organisation,
                  goalsState: goalsState,
                  showCounts: showCounts,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context, {
    required CollectGroup organisation,
    required ForYouGoalsState goalsState,
    required bool showCounts,
  }) {
    final theme = FunTheme.of(context);
    final summary =
        goalsState.summariesByCollectGroupId[organisation.nameSpace];
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _openForYouGiving(organisation),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.highlight99,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.neutralVariant90,
                width: theme.borderWidthThinner,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: theme.primary95,
                      child: Icon(
                        CollectGroupType.getIconByType(organisation.type),
                        color: theme.primary20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabelMediumText(
                            organisation.orgName,
                            color: theme.primary20,
                          ),
                          if (organisation.locations.isNotEmpty)
                            BodySmallText(
                              organisation.locations.first.name,
                              color: theme.primary20,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  color: theme.neutralVariant95,
                ),
                const SizedBox(height: 12),
                if (showCounts && summary != null) ...[
                  BodySmallText(
                    context.l10n.forYouGoalsCountCollections(
                      summary.allocationsCount,
                    ),
                    color: theme.primary20,
                  ),
                  BodySmallText(
                    context.l10n.forYouGoalsCountGeneral(summary.qrCodesCount),
                    color: theme.primary20,
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            top: -16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.error90,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 14,
                      color: theme.error40,
                    ),
                    const SizedBox(width: 6),
                    LabelSmallText(
                      context.l10n.forYouFavoriteTag,
                      color: theme.error40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators(
    BuildContext context, {
    required int count,
    required int current,
  }) {
    final theme = FunTheme.of(context);
    final dotCount = count.clamp(1, 5);
    final effectiveCurrent = current.clamp(0, dotCount - 1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(dotCount, (index) {
        final isSelected = index == effectiveCurrent;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? theme.primary20 : theme.neutral80,
          ),
        );
      }),
    );
  }

  Widget _buildSearchRow(
    BuildContext context, {
    required String title,
    required AnalyticsEvent analyticsEvent,
  }) {
    return FunInput(
      hintText: title,
      readOnly: true,
      heroTag: 'discover_search_input_hero',
      analyticsEvent: analyticsEvent,
      onTap: () => _openForYouList(ForYouEntrySource.search),
    );
  }

  Widget _buildOtherWayTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String imageUrl,
    required FunTileVariant variant,
    required AnalyticsEvent analyticsEvent,
    required VoidCallback onTap,
  }) {
    return FunTile(
      iconPath: imageUrl,
      analyticsEvent: analyticsEvent,
      onTap: onTap,
      variant: variant,
      mainAxisAlignment: MainAxisAlignment.center,
      titleBig: title,
      subtitle: subtitle,
    );
  }

  void _openForYouList(ForYouEntrySource source) {
    context.goNamed(
      Pages.forYouList.name,
      extra: ForYouFlowContext(source: source).toMap(),
    );
  }

  void _openForYouDiscovery(ForYouEntrySource source) {
    final namedRoute = switch (source) {
      ForYouEntrySource.location => Pages.forYouByLocation.name,
      ForYouEntrySource.qrCode => Pages.forYouByQrCode.name,
      ForYouEntrySource.collectionDevice => Pages.forYouByBeacon.name,
      _ => Pages.forYouList.name,
    };

    context.goNamed(
      namedRoute,
      extra: ForYouFlowContext(source: source).toMap(),
    );
  }

  void _openForYouGiving(CollectGroup organisation) {
    AnalyticsHelper.logEvent(
      eventName: AnalyticsEventName.forYouFavoriteTapped,
      eventProperties: {
        'organisation_name': organisation.orgName,
      },
    );
    context.goNamed(
      Pages.forYouGiving.name,
      extra: ForYouFlowContext(
        source: ForYouEntrySource.favorite,
        selectedOrganisation: organisation,
      ).toMap(),
    );
  }
}
