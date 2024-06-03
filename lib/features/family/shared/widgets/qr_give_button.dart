import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class QrGiveButton extends StatelessWidget {
  const QrGiveButton({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isActive
          ? () {
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.iWantToGivePressed,
                eventProperties: {
                  'current_amount_in_wallet': context
                      .read<ProfilesCubit>()
                      .state
                      .activeProfile
                      .wallet
                      .balance,
                },
              );
              context.pushNamed(Pages.camera.name);
            }
          : null,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.maxFinite, 60),
        backgroundColor: const Color(0xFFE28D4D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      icon: SvgPicture.asset("assets/family/images/qr_icon.svg"),
      label: const Padding(
        padding: EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 10,
        ),
        child: Text(
          "I want to give",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF1EAE2),
          ),
        ),
      ),
    );
  }
}
