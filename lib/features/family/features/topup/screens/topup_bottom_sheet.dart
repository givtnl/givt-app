import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/family/features/topup/cubit/topup_cubit.dart';
import 'package:givt_app/features/family/features/topup/screens/topup_error_bottom_sheet.dart';
import 'package:givt_app/features/family/features/topup/screens/topup_initial_bottom_sheet.dart';
import 'package:givt_app/features/family/features/topup/screens/topup_loading_bottom_sheet.dart';
import 'package:givt_app/features/family/features/topup/screens/topup_success_bottom_sheet.dart';

class TopupWalletBottomSheet extends StatefulWidget {
  const TopupWalletBottomSheet({super.key});

  @override
  State<TopupWalletBottomSheet> createState() => _TopupWalletBottomSheetState();
}

class _TopupWalletBottomSheetState extends State<TopupWalletBottomSheet> {
  int topupAmount = 5;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopupCubit, TopupState>(
      builder: (context, state) {
        switch (state.status) {
          case TopupStatus.initial:
            return TopupInitialBottomSheet(
              topupAmount: topupAmount,
              amountChanged: (amount) {
                setState(() {
                  topupAmount = amount;
                });
              },
            );

          case TopupStatus.loading:
            return const TopupLoadingBottomSheet();

          case TopupStatus.done:
            return TopupSuccessBottomSheet(topupAmount: topupAmount);

          case TopupStatus.error:
            return const TopupErrorBottomSheet();
        }
      },
    );
  }
}
