import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/set_up_allowance/cubit/generosity_allowances_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/set_up_allowance/widgets/wallet_intro_page.dart';

class GenerosityAllowanceFlowPage extends StatelessWidget {
  const GenerosityAllowanceFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerosityAllowancesCubit, GenerosityAllowancesState>(
      builder: (context, state) {
        switch (state.status) {
          case GenerosityAddAllowanceStatus.addAllowance:
            return Container(
              child: Text('Add allowance'),
            );
          case GenerosityAddAllowanceStatus.addAllowanceSuccess:
            return Container();
          case GenerosityAddAllowanceStatus.walletIntro:
            return WalletIntroPage(
              onContinue: () {
                context.read<GenerosityAllowancesCubit>().showAddAllowance();
              },
            );
        }
      },
    );
  }
}
