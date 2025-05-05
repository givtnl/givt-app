import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/reward/presentation/models/reward_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/fun_dialog.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/models/fun_dialog_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_large_text.dart';
import 'package:givt_app/shared/widgets/animations/confetti_helper.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.uiModel.triggerAppReview) {
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.inAppReviewTriggered,
      );

      InAppReview.instance.requestReview();
    }
  }

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
            onTap: () async {
              ConfettiHelper.show(
                context,
                onFinished: () {
                  if (!context.mounted) return;
                  if (widget.uiModel.interviewUIModel != null) {
                    _showInterviewPopup(
                      context,
                      widget.uiModel.interviewUIModel!,
                      useDefaultImage: widget.uiModel.useDefaultInterviewIcon,
                    );
                  } else {
                    _navigateToProfileSelection(context);
                  }
                },
              );
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

  void _showInterviewPopup(
    BuildContext context,
    FunDialogUIModel uiModel, {
    bool useDefaultImage = true,
  }) {
    FunDialog.show(
      context,
      uiModel: uiModel,
      image: useDefaultImage ? FunIcon.solidComments() : FunIcon.moneyBill(),
      onClickPrimary: () {
        context.pop();
        launchCalendlyUrl();
        _navigateToProfileSelection(context);
      },
      onClickSecondary: () {
        context.pop();
        _navigateToProfileSelection(context);
      },
    );
  }

  Future<void> launchCalendlyUrl() async {
    const calendlyLink = 'https://calendly.com/andy-765/45min';

    final url = Uri.parse(calendlyLink);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // do nothing, we're probably on a weird platform/ simulator
    }
  }

  void _navigateToProfileSelection(BuildContext context) {
    context.goNamed(
      FamilyPages.profileSelection.name,
    );
  }
}
