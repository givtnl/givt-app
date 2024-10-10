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
  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      builder: (context) => const TopupWalletBottomSheet(),
    );
  }
}

class _TopupWalletBottomSheetState extends State<TopupWalletBottomSheet> {
  int topupAmount = 5;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopupCubit, TopupState>(
      builder: (context, state) {
        return switch (state) {
          InitialState() => const TopupInitialBottomSheet(),
          LoadingState() => const TopupLoadingBottomSheet(),
          SuccessState() => TopupSuccessBottomSheet(
              topupAmount: state.amount,
              recurring: state.recurring,
            ),
          ErrorState() => const TopupErrorBottomSheet(),
        };
      },
    );
  }
}
