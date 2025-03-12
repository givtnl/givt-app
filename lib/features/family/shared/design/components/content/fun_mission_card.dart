import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_bar.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class FunMissionCard extends StatelessWidget {
  const FunMissionCard({
    required this.uiModel,
    required this.analyticsEvent,
    this.onTap,
    this.isLoading = false,
    super.key,
  });

  factory FunMissionCard.loading() => FunMissionCard(
        uiModel: FunMissionCardUIModel(
          title: 'Loading...',
          description: '',
        ),
        isLoading: true,
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.loading,
        ),
      );

  final FunMissionCardUIModel uiModel;
  final VoidCallback? onTap;
  final bool isLoading;
  final AnalyticsEvent analyticsEvent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();

        unawaited(
          AnalyticsHelper.logEvent(
            eventName: analyticsEvent.name,
            eventProperties: analyticsEvent.parameters,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: FamilyAppTheme.highlight99,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: FamilyAppTheme.neutralVariant95,
            width: 2,
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (uiModel.headerIcon != null) uiModel.headerIcon!,
                        const SizedBox(height: 12),
                        TitleSmallText(
                          uiModel.title,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        BodySmallText.primary40(uiModel.description),
                        if (uiModel.progress != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: GoalProgressBar(
                              model: uiModel.progress!,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (onTap != null)
                    Align(
                      alignment: Alignment.topRight,
                      child: FaIcon(
                        semanticLabel: 'icon-${uiModel.actionIcon.fontFamily}-${uiModel.actionIcon.codePoint}',
                        uiModel.actionIcon,
                        color: FamilyAppTheme.primary40.withOpacity(0.75),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
