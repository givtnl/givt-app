import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/set_up_allowance/widgets/wallet_intro_page.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_save_key.dart';
import 'package:givt_app/features/children/overview/pages/edit_allowance_page.dart';
import 'package:givt_app/features/children/overview/pages/edit_allowance_success_page.dart';
import 'package:givt_app/features/children/overview/pages/models/edit_allowance_success_uimodel.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:go_router/go_router.dart';

class GenerosityAllowanceFlowPage extends StatelessWidget {
  const GenerosityAllowanceFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WalletIntroPage(onContinue: () {
      _navigateToEditAllowanceScreen(context);
    });
  }

  Future<void> _navigateToEditAllowanceScreen(
    BuildContext context,
  ) async {
    final dynamic result = await Navigator.push(
      context,
      EditAllowancePage(
        extraHeader: _allowancesHeader(context),
        currency: r'$',
        initialAllowance: 15,
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
                    // TODO integrate with add member & navigate to VPC KIDS-957
                    // for now it navigates back to the assignment screen
                    context
                      ..pop()
                      ..pop();
                  },
                ),
              ).toRoute(context),
            ),
          );
    }
  }

  Widget _allowancesHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'Add an amount',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Foster your children’s spirit of giving.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
