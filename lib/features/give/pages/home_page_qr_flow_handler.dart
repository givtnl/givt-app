import 'package:flutter/material.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:go_router/go_router.dart';

/// Helper class to handle QR code flow logic for home page
class HomePageQRFlowHandler {
  /// Checks if we're in QR code flow
  static bool isQRFlow(GiveState state, String code, GiveBloc? giveBloc) {
    final hasOrganisation =
        state.organisation.mediumId != null &&
        state.organisation.mediumId!.isNotEmpty;
    return (state.status == GiveStatus.readyToGive ||
            (hasOrganisation && code.isNotEmpty)) &&
        giveBloc != null &&
        code.isNotEmpty;
  }

  /// Helper to show loading dialog with fullscreen white background
  static void showLoadingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white,
      useSafeArea: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: CustomCircularProgressIndicator(),
        ),
      ),
    );
  }

  /// Helper to dismiss loading dialog
  static void dismissLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  /// Helper to navigate to select giving way page with amounts
  static void navigateToSelectGivingWay(
    BuildContext context,
    double firstCollection,
    double secondCollection,
    double thirdCollection,
    String code,
    String afterGivingRedirection,
  ) {
    context.goNamed(
      Pages.selectGivingWay.name,
      extra: {
        'firstCollection': firstCollection,
        'secondCollection': secondCollection,
        'thirdCollection': thirdCollection,
        'code': code,
        'afterGivingRedirection': afterGivingRedirection,
      },
    );
  }

  /// Helper to wait for state to match expected values
  static Future<GiveState?> waitForState(
    GiveBloc bloc,
    bool Function(GiveState) condition, {
    int maxAttempts = 10,
    Duration delay = const Duration(milliseconds: 100),
    required bool Function() mounted,
  }) async {
    await Future<void>.delayed(delay);
    if (!mounted()) return null;

    var state = bloc.state;
    var attempts = 0;

    while (attempts < maxAttempts && !condition(state)) {
      await Future<void>.delayed(delay);
      if (!mounted()) return null;
      state = bloc.state;
      attempts++;
    }

    return condition(state) ? state : null;
  }

  /// Handles QR code flow: updates amounts, submits transactions, and navigates
  static Future<void> handleQRFlow(
    BuildContext context,
    GiveBloc bloc,
    double firstCollection,
    double secondCollection,
    double thirdCollection,
    String code,
    String afterGivingRedirection,
    bool Function() mounted,
  ) async {
    final currentState = bloc.state;

    LoggingInfo.instance.info(
      'QR flow: Next button clicked - status: ${currentState.status}, '
      'hasOrg: ${currentState.organisation.mediumId?.isNotEmpty ?? false}, '
      'code: $code',
    );

    showLoadingDialog(context);

    try {
      // Update amounts - this will recreate transactions in GiveBloc
      bloc.add(
        GiveAmountChanged(
          firstCollectionAmount: firstCollection,
          secondCollectionAmount: secondCollection,
          thirdCollectionAmount: thirdCollection,
        ),
      );

      // Wait for state to update with new transactions
      final updatedState = await waitForState(
        bloc,
        (state) =>
            state.status == GiveStatus.readyToGive &&
            state.collections[0] == firstCollection &&
            state.collections[1] == secondCollection &&
            state.collections[2] == thirdCollection,
        mounted: mounted,
      );

      if (!mounted() || updatedState == null) {
        dismissLoadingDialog(context);
        if (mounted()) {
          navigateToSelectGivingWay(
            context,
            firstCollection,
            secondCollection,
            thirdCollection,
            code,
            afterGivingRedirection,
          );
        }
        return;
      }

      // Submit transactions if they haven't been submitted yet
      if (updatedState.transactionIds.isEmpty &&
          updatedState.givtTransactions.isNotEmpty) {
        LoggingInfo.instance.info('QR flow: Submitting transactions');
        bloc.add(const GiveSubmitTransactions());

        final submissionState = await waitForState(
          bloc,
          (state) =>
              state.status == GiveStatus.readyToGive ||
              state.status == GiveStatus.noInternetConnection ||
              state.status == GiveStatus.error,
          delay: const Duration(milliseconds: 200),
          mounted: mounted,
        );

        if (!mounted()) {
          dismissLoadingDialog(context);
          return;
        }

        if (submissionState?.status == GiveStatus.error) {
          LoggingInfo.instance.error('QR flow: Transaction submission failed');
          dismissLoadingDialog(context);
          navigateToSelectGivingWay(
            context,
            firstCollection,
            secondCollection,
            thirdCollection,
            code,
            afterGivingRedirection,
          );
          return;
        }
      }

      if (!mounted()) {
        dismissLoadingDialog(context);
        return;
      }

      // Verify we have transactionIds before navigating
      final finalState = bloc.state;
      LoggingInfo.instance.info(
        'QR flow: Final state - status: ${finalState.status}, '
        'transactionIds: ${finalState.transactionIds.length}, '
        'transactions: ${finalState.givtTransactions.length}',
      );

      dismissLoadingDialog(context);

      if (!mounted()) return;

      if (finalState.transactionIds.isNotEmpty) {
        context.goNamed(
          Pages.give.name,
          extra: bloc,
        );
      } else {
        LoggingInfo.instance.error(
          'QR flow: No transactionIds after submission. '
          'Status: ${finalState.status}, '
          'Transactions: ${finalState.givtTransactions.length}',
        );
        navigateToSelectGivingWay(
          context,
          firstCollection,
          secondCollection,
          thirdCollection,
          code,
          afterGivingRedirection,
        );
      }
    } catch (e) {
      LoggingInfo.instance.error('QR flow: Error - $e');
      dismissLoadingDialog(context);
      if (mounted()) {
        navigateToSelectGivingWay(
          context,
          firstCollection,
          secondCollection,
          thirdCollection,
          code,
          afterGivingRedirection,
        );
      }
    }
  }
}
