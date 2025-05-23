import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/helpers/vibrator.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/back_home_button.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/switch_profile_success_button.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SuccessCoinScreen extends StatefulWidget {
  const SuccessCoinScreen({
    required this.isGoal,
    super.key,
  });

  final bool isGoal;

  @override
  State<SuccessCoinScreen> createState() => _SuccessCoinScreenState();
}

class _SuccessCoinScreenState extends State<SuccessCoinScreen> {
  @override
  void initState() {
    super.initState();

    Vibrator.tryVibratePattern();
  }

  @override
  Widget build(BuildContext context) {
    final profilesState = context.read<ProfilesCubit>().state;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: FamilyAppTheme.secondary98,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: FamilyAppTheme.secondary98,
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
              _buildSuccessText(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildFAB(profilesState.isOnlyChild),
        ),
      ),
    );
  }

  Widget _buildSuccessText() {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
        child: Column(
          children: [
            TitleMediumText(
              widget.isGoal ? 'Well done!' : 'Activated!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.isGoal
                  ? 'You helped towards your family goal!'
                  : 'Drop your coin in\nthe giving box.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: FamilyAppTheme.defaultTextColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(bool isOnlyChild) {
    if (widget.isGoal) {
      return FunButton(
        text: context.l10n.buttonDone,
        onTap: () {
          context.goNamed(FamilyPages.wallet.name);
          context.read<FlowsCubit>().resetFlow();
        },
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.returnToHomePressed,
        ),
      );
    }
    if (isOnlyChild) {
      return const BackHomeButton();
    }
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BackHomeButton(),
        SizedBox(height: 12),
        SwitchProfileSuccessButton(),
      ],
    );
  }
}
