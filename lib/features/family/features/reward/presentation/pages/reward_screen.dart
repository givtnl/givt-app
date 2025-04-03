import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/reward/presentation/models/reward_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_large_text.dart';
import 'package:givt_app/shared/dialogs/confetti_dialog.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({
    required this.uiModel,
    super.key,
  });

  final RewardUIModel uiModel;

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          if (widget.uiModel.rewardImage == null)
            SvgPicture.asset(
              'assets/family/images/reward.svg',
            ),
          if (widget.uiModel.rewardImage != null &&
              widget.uiModel.rewardImage!.endsWith('.svg'))
            SvgPicture.asset(
              widget.uiModel.rewardImage!,
            ),
          if (widget.uiModel.rewardImage != null &&
              !widget.uiModel.rewardImage!.endsWith('.svg'))
            Image.asset(
              widget.uiModel.rewardImage!,
            ),
          const SizedBox(height: 16),
          TitleLargeText(
            widget.uiModel.rewardText,
          ),
          const Spacer(),
          FunButton(
            onTap: () {
              ConfettiDialog.show(context);
              Future.delayed(const Duration(milliseconds: 1500), () {
                if (!context.mounted) return;
                context.goNamed(
                  FamilyPages.profileSelection.name,
                  queryParameters: {
                    'checkForRewardOverlay': 'true',
                  },
                );
              });
            },
            text: 'Claim reward',
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.claimRewardClicked,
              parameters: {
                'reward': widget.uiModel.rewardText,
                'rewardImage': widget.uiModel.rewardImage,
              },
            ),
          ),
        ],
      ),
    );
  }
}
