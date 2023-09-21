import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/vpc/widgets/vpc_intro_item_image.dart';
import 'package:givt_app/features/children/vpc/widgets/vpc_notice_dialog.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/utils.dart';

class VPCIntroItemSafety extends StatelessWidget {
  const VPCIntroItemSafety({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context);
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Text(
              locals.vpcIntroSafetyText,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: AppTheme.sliderIndicatorFilled),
            ),
          ),
          const VPCIntroItemImage(
            background: 'assets/images/vpc_intro_safety_bg.svg',
            foreground: 'assets/images/vpc_intro_safety.svg',
          ),
          TextButton(
            onPressed: () {
              AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.directNoticeClicked);
              showModalBottomSheet<void>(
                context: context,
                backgroundColor: AppTheme.givtPurple,
                showDragHandle: true,
                useSafeArea: true,
                builder: (context) => const VPCNoticeDialog(),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  locals.seeDirectNoticeButtonText,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: AppTheme.sliderIndicatorFilled),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.info_outline),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
