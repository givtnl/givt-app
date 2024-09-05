import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/flows/cubit/flow_type.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class SwitchProfileSuccessButton extends StatelessWidget {
  const SwitchProfileSuccessButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final flowsCubit = context.read<FlowsCubit>();
    final profilesCubit = context.read<ProfilesCubit>();

    return FunButton.tertiary(
      text: 'Switch profile',
      leadingImage: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SvgPicture.network(
          profilesCubit.state.activeProfile.pictureURL,
          height: 32,
          width: 32,
        ),
      ),
      onTap: () async {
        if (flowsCubit.state.flowType == FlowType.deepLinkCoin) {
          flowsCubit.startInAppCoinFlow();
        }

        context.goNamed(FamilyPages.profileSelection.name);
      },
      amplitudeEvent: AmplitudeEvents.profileSwitchPressed,
    );
  }
}
