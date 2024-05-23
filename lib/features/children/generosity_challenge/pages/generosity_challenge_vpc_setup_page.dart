import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/children/add_member/widgets/vpc_page.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_vpc_setup_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_vpc_setup_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/setting_up_family_space_loading_widget.dart';

class GenerosityChallengeVpcSetupPage extends StatefulWidget {
  const GenerosityChallengeVpcSetupPage({super.key});

  @override
  State<GenerosityChallengeVpcSetupPage> createState() =>
      _GenerosityChallengeVpcSetupPageState();
}

class _GenerosityChallengeVpcSetupPageState
    extends State<GenerosityChallengeVpcSetupPage> {
  final _cubit = getIt<GenerosityChallengeVpcSetupCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseStateConsumer(
        onLoading: (BuildContext context) {
          return const SettingUpFamilySpaceLoadingWidget();
        },
        onData: (BuildContext context, uiModel) {
          return _vpc(context);
        },
        onInitial: _vpc,
        bloc: _cubit,
      ),
    );
  }

  VPCPage _vpc(BuildContext context) {
    return VPCPage(
      onReadyClicked: _cubit.onClickReadyForVPC,
    );
  }
}
