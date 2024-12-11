import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/widgets/organisation_item.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/recommendations_ui_model.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_text_styles.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class RecommendationsListWidget extends StatefulWidget {
  const RecommendationsListWidget({
    required this.uiModel,
    super.key,
    this.onRecommendationChosen,
    this.onSkip,
  });

  final RecommendationsUIModel uiModel;
  final void Function(int index)? onRecommendationChosen;
  final void Function()? onSkip;

  @override
  State<RecommendationsListWidget> createState() =>
      _RecommendationsListWidgetState();
}

class _RecommendationsListWidgetState extends State<RecommendationsListWidget> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void didUpdateWidget(covariant RecommendationsListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.uiModel != oldWidget.uiModel) {
      _carouselController.jumpToPage(0);
      setState(() {
        _currentIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardHeight = 16 +
        40 + // action container margin and padding
        MediaQuery.textScalerOf(context)
                .scale(FunTextStyles.labelSmall.fontSize ?? 14) *
            (FunTextStyles.titleSmall.height ?? 1.2) +
        6 + // top label text and padding
        150 +
        24 + //img height and padding
        MediaQuery.textScalerOf(context)
                .scale(FunTextStyles.titleSmall.fontSize ?? 18) *
            (FunTextStyles.titleSmall.height ??
                1.2) + // big title scaled by line height and accessiblity
        48; // big title padding
    final width = MediaQuery.of(context).size.width;
    final viewportFraction = (width - 48) / width;
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: cardHeight),
          child: CarouselSlider.builder(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: cardHeight,
              viewportFraction: viewportFraction,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            itemCount: widget.uiModel.isNotLoggedInParent &&
                    !widget.uiModel.showActsOfService
                ? widget.uiModel.organisations.length + 1
                : widget.uiModel.organisations.length,
            itemBuilder: (context, index, realIndex) {
              if (widget.uiModel.isNotLoggedInParent &&
                  !widget.uiModel.showActsOfService &&
                  index == 0) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                  child: TitleSmallText(
                    "Right now, only the logged in parent can donate using their account. We're working on a way to allow all parents to be able to do this in the game. Stay tuned!",
                    color: Colors.black.withOpacity(0.25),
                  ),
                );
              }
              final recommendationIndex = widget.uiModel.isNotLoggedInParent &&
                      !widget.uiModel.showActsOfService
                  ? index - 1
                  : index;
              final recommendation =
                  widget.uiModel.organisations[recommendationIndex];
              return Container(
                width: width - 48,
                padding: const EdgeInsets.only(right: 12),
                child: OrganisationItem(
                  isActOfService: widget.uiModel.showActsOfService,
                  nrOfTags: 1,
                  organisation: recommendation,
                  onDonateClicked: () {
                    widget.onRecommendationChosen?.call(_currentIndex);
                    context.pop(); //close bottomsheet
                  },
                  userName: widget.uiModel.name,
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.uiModel.isNotLoggedInParent &&
                    !widget.uiModel.showActsOfService
                ? widget.uiModel.organisations.length + 1
                : widget.uiModel.organisations.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? FamilyAppTheme.primary40
                    : Colors.black.withOpacity(0.1),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (!widget.uiModel.isNotLoggedInParent ||
            widget.uiModel.showActsOfService)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FunButton(
              onTap: () => widget.onRecommendationChosen?.call(_currentIndex),
              text: widget.uiModel.showActsOfService
                  ? "I'm going to do this"
                  : 'Give',
              analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.newActOfGenerosityClicked,
                  parameters: {
                    widget.uiModel.showActsOfService
                            ? 'act_of_service'
                            : 'donation':
                        widget.uiModel.organisations[_currentIndex].name,
                  }),
            ),
          ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            widget.onSkip?.call();
            unawaited(
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.skipGenerosActPressed,
              ),
            );
          },
          child: const LabelLargeText('Skip this time'),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
