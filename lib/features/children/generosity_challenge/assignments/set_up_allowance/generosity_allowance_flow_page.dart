import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/set_up_allowance/widgets/wallet_intro_page.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/pages/generosity_challenge_vpc_setup_page.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_save_key.dart';
import 'package:givt_app/features/children/overview/pages/edit_allowance_page.dart';
import 'package:givt_app/features/children/overview/pages/edit_allowance_success_page.dart';
import 'package:givt_app/features/children/overview/pages/models/edit_allowance_success_uimodel.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';

class GenerosityAllowanceFlowPage extends StatelessWidget {
  const GenerosityAllowanceFlowPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WalletIntroPage(
      onContinue: () {
        _navigateToEditAllowanceScreen(context);
      },
    );
  }

  Future<void> _navigateToEditAllowanceScreen(
    BuildContext context,
  ) async {
    final cubit = context.read<GenerosityChallengeCubit>();
    final nrOfChildren = cubit.getNrOfChildren();
    var childName = '';
    if (nrOfChildren == 1) {
      childName = await cubit.getChildName(1);
    }
    final dynamic result = await Navigator.push(
      context,
      EditAllowancePage(
        currency: r'$',
        isMultipleChildren: nrOfChildren > 1,
        childName: childName,
      ).toRoute(context),
    );
    if (result != null && result is int && context.mounted) {
      await context
          .read<GenerosityChallengeCubit>()
          .saveUserDataByKey(
            ChatScriptSaveKey.allowanceAmount,
            result.toString(),
          )
          .then(
            (value) => Navigator.push(
              context,
              EditAllowanceSuccessPage(
                uiModel: EditAllowanceSuccessUIModel(
                  amountWithCurrencySymbol: '\$$result',
                  onClickButton: () {
                    Navigator.of(context).push(
                      const GenerosityChallengeVpcSetupPage().toRoute(context),
                    );
                  },
                ),
              ).toRoute(context),
            ),
          );
    }
  }
}
