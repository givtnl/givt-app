import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/topup/cubit/topup_cubit.dart';
import 'package:givt_app/features/family/features/topup/screens/topup_error_bottom_sheet.dart';
import 'package:givt_app/features/family/features/topup/screens/topup_initial_bottom_sheet.dart';
import 'package:givt_app/features/family/features/topup/screens/topup_loading_bottom_sheet.dart';
import 'package:givt_app/features/family/features/topup/screens/topup_success_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/widgets/errors/retry_error_widget.dart';

class TopupWalletBottomSheet extends StatefulWidget {
  const TopupWalletBottomSheet(
      {required this.onTopupSuccess,
      this.awaitActiveProfileBalance = false,
      super.key});
  final VoidCallback onTopupSuccess;
  final bool awaitActiveProfileBalance;
  @override
  State<TopupWalletBottomSheet> createState() => _TopupWalletBottomSheetState();
  static void show(BuildContext context, VoidCallback onTopupSuccess,
      bool? awaitActiveProfileBalance) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      builder: (context) => TopupWalletBottomSheet(
        onTopupSuccess: onTopupSuccess,
        awaitActiveProfileBalance: awaitActiveProfileBalance ?? false,
      ),
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
          SuccessState() =>
            _buildSuccessState(state, widget.awaitActiveProfileBalance),
          ErrorState() => const TopupErrorBottomSheet(),
        };
      },
    );
  }

  Widget _buildSuccessState(
      SuccessState success, bool awaitActiveProfileBalance) {
    if (awaitActiveProfileBalance) {
      return BlocBuilder<ProfilesCubit, ProfilesState>(
        builder: (context, state) {
          if (state.activeProfile.wallet.balance == 0) {
            return FutureBuilder(
              future: Future.delayed(const Duration(seconds: 30)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const TopupLoadingBottomSheet();
                } else {
                  return RetryErrorWidget(onTapPrimaryButton: () {
                    context.read<ProfilesCubit>().refresh();
                  });
                }
              },
            );
          }
          return TopupSuccessBottomSheet(
            topupAmount: success.amount,
            recurring: success.recurring,
            onSuccess: widget.onTopupSuccess,
          );
        },
      );
    }
    return TopupSuccessBottomSheet(
      topupAmount: success.amount,
      recurring: success.recurring,
      onSuccess: widget.onTopupSuccess,
    );
  }
}
