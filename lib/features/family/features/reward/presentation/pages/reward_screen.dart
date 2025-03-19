import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/reward/presentation/models/reward_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_large_text.dart';
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
          SvgPicture.asset(
            'assets/family/images/reward.svg',
          ),
          const SizedBox(height: 16),
          TitleLargeText(
            widget.uiModel.rewardText,
          ),
          const Spacer(),
          FunButton(
            onTap: () {
              context.goNamed(
                FamilyPages.profileSelection.name,
              );
            },
            text: 'Claim reward',
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.claimRewardClicked,
            ),
          ),
        ],
      ),
    );
  }
}
