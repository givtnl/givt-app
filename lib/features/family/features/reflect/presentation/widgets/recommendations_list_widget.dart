import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/widgets/organisation_item.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/recommendations_ui_model.dart';
import 'package:givt_app/features/family/shared/design/components/content/pager_dot_indicator.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_text_styles.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:go_router/go_router.dart';

class RecommendationsListWidget extends StatefulWidget {
  const RecommendationsListWidget({
    required this.uiModel,
    super.key,
    this.onRecommendationChosen,
    this.onSkip,
    this.onIndexChanged, // Add this line
  });

  final RecommendationsUIModel uiModel;
  final void Function(int index)? onRecommendationChosen;
  final void Function()? onSkip;
  final void Function(int index)? onIndexChanged; // Add this line

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
        widget.onIndexChanged?.call(0);
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
        10 + // top label text and padding
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
                widget.onIndexChanged?.call(index);
              },
            ),
            itemCount: widget.uiModel.isNotLoggedInParent &&
                    !widget.uiModel.isShowingActsOfService
                ? widget.uiModel.organisations.length + 1
                : widget.uiModel.organisations.length,
            itemBuilder: (context, index, realIndex) {
              if (widget.uiModel.isNotLoggedInParent &&
                  !widget.uiModel.isShowingActsOfService &&
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
                      !widget.uiModel.isShowingActsOfService
                  ? index - 1
                  : index;
              final recommendation =
                  widget.uiModel.organisations[recommendationIndex];

              return Container(
                width: width - 48,
                padding: const EdgeInsets.only(right: 12),
                child: OrganisationItem(
                  isActOfService: widget.uiModel.isShowingActsOfService,
                  nrOfTags: recommendation.tags.length,
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
        PagerDotIndicator(
          count: widget.uiModel.organisations.length,
          index: _currentIndex,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
