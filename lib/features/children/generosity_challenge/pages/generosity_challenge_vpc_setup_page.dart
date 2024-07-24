import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/features/children/add_member/widgets/vpc_page.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_vpc_setup_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_vpc_setup_custom.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/setting_up_family_space_loading_widget.dart';
import 'package:go_router/go_router.dart';

class GenerosityChallengeVpcSetupPage extends StatefulWidget {
  const GenerosityChallengeVpcSetupPage({
    super.key,
  });

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
        cubit: _cubit,
        onCustom: _onCustom,
      ),
    );
  }

  Scaffold _vpc(BuildContext context) {
    return Scaffold(
      appBar: const GenerosityAppBar(
        title: 'Parental Permission',
        leading: GenerosityBackButton(),
      ),
      body: VPCPage(
        onReadyClicked: _cubit.onClickReadyForVPC,
      ),
    );
  }

  void _onCustom(
    BuildContext context,
    GenerosityChallengeVpcSetupCustom custom,
  ) {
    switch (custom) {
      case NavigateToFamilyOverview():
        context
          ..pushReplacementNamed(FamilyPages.profileSelection.name)
          ..pushNamed(FamilyPages.childrenOverview.name);
      case NavigateToLogin():
        context.goNamed(Pages.welcome.name);
    }
  }
}
