import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/create_child/widgets/giving_allowance_info_bottom_sheet.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class GivingAllowanceInfoButton extends StatelessWidget {
  const GivingAllowanceInfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.infoGivingAllowanceClicked,
        );

        showModalBottomSheet<void>(
          context: context,
          backgroundColor: AppTheme.givtPurple,
          showDragHandle: true,
          useSafeArea: true,
          builder: (context) => const GivingAllowanceInfoBottomSheet(),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/refresh_arrows.svg',
            width: 20,
          ),
          const SizedBox(width: 10),
          Text(
            context.l10n.createChildGivingAllowanceTitle,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 16,
                ),
          ),
          const SizedBox(width: 10),
          Icon(
            Icons.info_rounded,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
