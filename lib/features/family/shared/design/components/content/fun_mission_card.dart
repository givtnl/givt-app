import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_progressbar.dart';
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
    this.useFunProgressbar = false,
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
  final bool useFunProgressbar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        unawaited(
          AnalyticsHelper.logEvent(
            eventName: analyticsEvent.name,
            eventProperties: analyticsEvent.parameters,
          ),
        );

        onTap?.call();
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
                        if (uiModel.headerIcon != null)
                          uiModel.disabled
                              ? uiModel.headerIcon!.copyWith(
                                  iconColorOverride: FamilyAppTheme.neutral40,
                                )
                              : uiModel.headerIcon!,
                        const SizedBox(height: 12),
                        TitleSmallText(
                          uiModel.title,
                          textAlign: TextAlign.center,
                          color: uiModel.disabled
                              ? FamilyAppTheme.neutral50
                              : null,
                        ),
                        const SizedBox(height: 4),
                        BodySmallText(
                          uiModel.description,
                          color: uiModel.disabled
                              ? FamilyAppTheme.neutral60
                              : FamilyAppTheme.primary40,
                          textAlign: TextAlign.center,
                        ),
                        if (uiModel.progress != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: useFunProgressbar ? FunProgressbar(
                              currentProgress: uiModel.progress!.amount.toInt(),
                              total: uiModel.progress!.totalAmount.toInt(),
                              backgroundColor: FamilyAppTheme.neutralVariant95,
                              progressColor: FamilyAppTheme.primary90,
                              textColor: FamilyAppTheme.primary20,
                              suffix: uiModel.progress!.suffix,
                            ) : GoalProgressBar(
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
                        semanticLabel:
                            'icon-${uiModel.actionIcon.fontFamily}-${uiModel.actionIcon.codePoint}',
                        uiModel.actionIcon,
                        color: FamilyAppTheme.primary40.withValues(alpha: 0.75),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
