import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_bar.dart';

class FunMissionCard extends StatelessWidget {
  const FunMissionCard({
    required this.uiModel,
    this.onTap,
    this.isLoading = false,
    super.key,
  });
  factory FunMissionCard.loading() => FunMissionCard(
        uiModel: FunMissionCardUiModel(
          title: 'Loading...',
          description: '',
        ),
        onTap: () {},
        isLoading: true,
      );

  final FunMissionCardUiModel uiModel;
  final VoidCallback? onTap;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Container(
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
        horizontal: 20,
        vertical: 16,
      ),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: onTap,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (uiModel.headerIcon != null)
                          FaIcon(uiModel.headerIcon,
                              color: FamilyAppTheme.primary60),
                        const SizedBox(height: 12),
                        TitleSmallText(
                          uiModel.title,
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
                        uiModel.actionIcon,
                        color: FamilyAppTheme.primary40.withOpacity(0.75),
                      ),
                    )
                ],
              ),
            ),
    );
  }
}
