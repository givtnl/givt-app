import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/family_home_screen.uimodel.dart';
import 'package:givt_app/features/family/features/unlocked_badge/repository/models/features.dart';
import 'package:givt_app/features/family/shared/design/components/content/avatar_bar.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_top_app_bar.dart';
import 'package:givt_app/features/family/shared/widgets/content/tutorial/fun_tooltip.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_large_text.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

class FamilyHomeOverlay extends StatefulWidget {
  const FamilyHomeOverlay({
    required this.uiModel,
    required this.onDismiss,
    required this.onNextTutorialClicked,
    required this.onAvatarTapped,
    this.withTutorial = false,
    this.withRewardText = false,
    this.openNewGame = false,
    super.key,
  });

  final FamilyHomeScreenUIModel uiModel;
  final bool withTutorial;
  final bool withRewardText;
  final bool openNewGame;
  final void Function() onNextTutorialClicked;
  final void Function() onDismiss;
  final void Function(int index) onAvatarTapped;

  @override
  State<FamilyHomeOverlay> createState() => _FamilyHomeOverlayState();
}

class _FamilyHomeOverlayState extends State<FamilyHomeOverlay> {
  final TooltipController controller = TooltipController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayTooltipScaffold(
      controller: controller,
      overlayColor: Colors.transparent,
      startWhen: (instantiatedWidgetLength) async {
        return widget.withTutorial;
      },
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 4,
          sigmaY: 4,
        ),
        child: FunScaffold(
          backgroundColor: FamilyAppTheme.primary50.withValues(alpha: 0.5),
          minimumPadding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
          appBar: const FunTopAppBar(
            title: null,
            color: Colors.transparent,
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onDismiss,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TitleLargeText(
                      widget.openNewGame
                          ? 'Who is going to play?'
                          : widget.withRewardText
                              ? context.l10n.homescreenOverlayDiscoverTitle
                              : context.l10n.homescreenOverlayGiveTitle,
                      textAlign: TextAlign.center,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 4),
                          blurRadius: 4,
                          color: Colors.black.withValues(alpha: 0.25),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  FunTooltip(
                    tooltipIndex: 0,
                    title: context.l10n.tutorialFamilyExplanationTitle,
                    description:
                        context.l10n.tutorialFamilyExplanationDescription,
                    labelBottomLeft: '1/6',
                    onButtonTap: () {
                      controller.dismiss();
                      widget.onNextTutorialClicked();
                      widget.onDismiss();
                    },
                    tooltipVerticalPosition: TooltipVerticalPosition.BOTTOM,
                    child: AvatarBar(
                      featureId: Features.familyHomeProfile,
                      circleSize: 58,
                      textColor: Colors.white,
                      uiModel: AvatarBarUIModel(
                        avatarUIModels: widget.uiModel.avatars,
                      ),
                      onAvatarTapped: widget.onAvatarTapped,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
