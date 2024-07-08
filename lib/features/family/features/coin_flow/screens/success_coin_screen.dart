import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/helpers/vibrator.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/back_home_button.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/switch_profile_success_button.dart';
import 'package:givt_app/utils/utils.dart';

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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppTheme.secondary98,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: AppTheme.secondary98,
      ),
      backgroundColor: AppTheme.secondary98,
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
      floatingActionButton: _buildFAB(profilesState.isOnlyChild),
    );
  }

  Widget _buildSuccessText() {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
        child: Column(
          children: [
            Text(
              widget.isGoal ? 'Well done!' : 'Activated!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.defaultTextColor,
                  ),
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
                    color: AppTheme.defaultTextColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(bool isOnlyChild) {
    if (widget.isGoal) {
      return GivtElevatedButton(
        text: 'Done',
        onTap: () {
          context.goNamed(FamilyPages.wallet.name);
          context.read<FlowsCubit>().resetFlow();

          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.returnToHomePressed,
          );
        },
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
