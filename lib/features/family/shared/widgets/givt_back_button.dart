import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';

import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class GivtBackButton extends StatefulWidget {
  const GivtBackButton({
    super.key,
    this.onPressedExt,
    this.onPressedForced,
  });

  final void Function()? onPressedExt;
  final void Function()? onPressedForced;

  @override
  State<GivtBackButton> createState() => _GivtBackButtonState();
}

class _GivtBackButtonState extends State<GivtBackButton> {
  double dropShadowHeight = 4;
  double paddingtop = 4;
  bool isPressed = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final flow = context.read<FlowsCubit>().state;
    //TODO: kids-576 Let's refactor it and make the button simple: either pop or not (and move navigation to the 'screen' level)
    final isDeepLink = !context.canPop() &&
        (flow.isCoin || flow.isRecommendation || flow.isQRCode);
    final isVisible =
        context.canPop() || isDeepLink || widget.onPressedForced != null;
    if (isPressed == true) {
      dropShadowHeight = 2;
      paddingtop = 4;
    } else {
      dropShadowHeight = 4;
      paddingtop = 2;
    }
    return Container(
      alignment: Alignment.center,
      child: Opacity(
        opacity: isVisible ? 1 : 0,
        child: AbsorbPointer(
          absorbing: !isVisible,
          child: Padding(
            padding: EdgeInsets.only(top: paddingtop),
            child: GestureDetector(
              onTap: () {
                // log amplitude in any case
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.backButtonPressed,
                );

                if (widget.onPressedForced != null) {
                  widget.onPressedForced!();
                } else if (isDeepLink) {
                  //TODO: kids-576 Let's refactor it and make the button simple: either pop or not (and move navigation to the 'screen' level)
                  context.goNamed(Pages.wallet.name);
                } else {
                  widget.onPressedExt?.call();
                  context.pop();
                }
              },
              onTapDown: (details) {
                SystemSound.play(SystemSoundType.click);
                setState(() {
                  isPressed = true;
                });
              },
              onTapCancel: () {
                HapticFeedback.lightImpact();
                setState(() {
                  isPressed = false;
                });
              },
              onTapUp: (details) {
                HapticFeedback.lightImpact();
                setState(() {
                  isPressed = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      blurRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                padding: EdgeInsets.only(
                  bottom: dropShadowHeight,
                  left: 2,
                  right: 2,
                  top: 2,
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Icon(
                    FontAwesomeIcons.arrowLeft,
                    size: 24,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
