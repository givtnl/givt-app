import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/vpc/cubit/vpc_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class VPCSuccessPage extends StatelessWidget {
  const VPCSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.vpcSuccessBackground,
      body: SafeArea(
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/images/logo_white.svg',
              height: size.height * 0.035,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.03),
                  SvgPicture.asset(
                    'assets/images/white_badge_check.svg',
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    locals.vpcSuccessTitle,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    locals.vpcSuccessText,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SvgPicture.asset('assets/images/vpc_givy.svg'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, bottom: 30),
              child: ElevatedButton(
                onPressed: () {
                  context.read<VPCCubit>().resetVPC();
                  context.goNamed(Pages.createChild.name);
                  AnalyticsHelper.logEvent(
                      eventName: AmplitudeEvents.setUpChildProfileClicked);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.sliderIndicatorFilled,
                ),
                child: Text(
                  locals.setupChildProfileButtonText,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
