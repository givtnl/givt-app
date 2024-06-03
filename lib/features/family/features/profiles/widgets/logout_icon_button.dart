import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/utils/utils.dart';

class LogoutIconButton extends StatelessWidget {
  const LogoutIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.logOutPressed,
        );
        context.read<AuthCubit>().logout();
        context.read<ProfilesCubit>().clearProfiles();
        context.read<FlowsCubit>().resetFlow();

        // TODO MAIKEL
        // context.goNamed(Pages.login.name);
      },
      icon: SvgPicture.asset(
        'assets/family/images/logout.svg',
        width: 36,
      ),
    );
  }
}
