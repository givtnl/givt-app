import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/giving_flow/collectgroup_details/cubit/collectgroup_details_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/helpers/vibrator.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/back_home_button.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/switch_profile_success_button.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

import 'package:lottie/lottie.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({
    super.key,
    this.isActOfService = false,
    this.onCustomSuccess,
  });
  final bool isActOfService;
  final void Function()? onCustomSuccess;
  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();

    Vibrator.tryVibratePattern();
  }

  @override
  Widget build(BuildContext context) {
    final organisation =
        context.read<CollectGroupDetailsCubit>().state.collectgroup;
    final profilesState = context.read<ProfilesCubit>().state;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: FamilyAppTheme.secondary98,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: FamilyAppTheme.secondary98,
        ),
      ),
      backgroundColor: FamilyAppTheme.secondary98,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Lottie.asset(
                'assets/family/lotties/rays.json',
                fit: BoxFit.fill,
                alignment: Alignment.bottomCenter,
                width: double.infinity,
              ),
            ),
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/family/images/box_success.svg',
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
                width: double.infinity,
              ),
            ),
            Positioned.fill(
              child: Lottie.asset(
                'assets/family/lotties/coin_drop_b.json',
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
                width: double.infinity,
              ),
            ),
            if (widget.isActOfService)
              Positioned.fill(
                child: Lottie.asset(
                  'assets/family/lotties/success_heart.json',
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                  width: double.infinity,
                ),
              ),
            Container(
              padding: const EdgeInsets.all(40),
              width: double.infinity,
              child: Column(
                children: [
                  TitleLargeText(
                    organisation.thankYou ?? 'Awesome!',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    widget.isActOfService
                        ? 'Good luck in completing your act of service'
                        : 'Thank you for your donation \n to ${organisation.name}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: widget.onCustomSuccess != null
            ? FunButton(
                onTap: widget.onCustomSuccess,
                text: 'Continue',
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.continueClicked,
                ),
              )
            : profilesState.isOnlyChild
                ? const BackHomeButton()
                : const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BackHomeButton(),
                      SizedBox(height: 12),
                      SwitchProfileSuccessButton(),
                    ],
                  ),
      ),
    );
  }
}
