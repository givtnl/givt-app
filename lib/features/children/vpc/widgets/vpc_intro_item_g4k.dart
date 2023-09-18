import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/vpc/cubit/vpc_cubit.dart';
import 'package:givt_app/features/children/vpc/widgets/vpc_intro_item_image.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/utils.dart';

class VPCIntroItemG4K extends StatelessWidget {
  const VPCIntroItemG4K({super.key});

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
              locals.vpcIntroG4KText,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: AppTheme.sliderIndicatorFilled),
            ),
          ),
          const VPCIntroItemImage(
            background: 'assets/images/vpc_intro_givt4kids_bg.svg',
            foreground: 'assets/images/vpc_intro_givt4kids.svg',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ElevatedButton(
              onPressed: () {
                AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.enterCardDetailsClicked);
                context
                    .read<VPCCubit>()
                    .fetchURL(context.read<AuthCubit>().state.user.guid);
              },
              child: Text(
                locals.enterCardDetailsButtonText,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
