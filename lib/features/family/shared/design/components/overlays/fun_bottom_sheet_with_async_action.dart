import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/bloc/fun_bottom_sheet_with_async_action_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/models/fun_bottom_sheet_with_async_action_state.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:go_router/go_router.dart';

class FunBottomSheetWithAsyncAction extends StatefulWidget {
  const FunBottomSheetWithAsyncAction({
    required this.cubit,
    required this.initialState,
    required this.loadingText,
    required this.successText,
    required this.analyticsName,
    super.key,
    this.successState,
    this.errorText,
  });

  final FunBottomSheetWithAsyncActionCubit cubit;
  final Widget initialState;
  final String loadingText;
  final String successText;
  final Widget? successState;
  final String? errorText;
  final String analyticsName;

  @override
  State<FunBottomSheetWithAsyncAction> createState() =>
      _FunBottomSheetWithAsyncActionState();

  static void show(
    BuildContext context, {
    required FunBottomSheetWithAsyncActionCubit cubit,
    required Widget initialState,
    required String loadingText,
    required String successText,
    required String analyticsName,
    Widget? successState,
    String? errorText,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      builder: (context) => FunBottomSheetWithAsyncAction(
        cubit: cubit,
        initialState: initialState,
        loadingText: loadingText,
        successText: successText,
        analyticsName: analyticsName,
        successState: successState,
        errorText: errorText,
      ),
    );
  }
}

class _FunBottomSheetWithAsyncActionState
    extends State<FunBottomSheetWithAsyncAction> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, __) => widget.cubit.onClose(),
      child: BlocBuilder(
        bloc: widget.cubit,
        builder:
            (BuildContext context, FunBottomSheetWithAsyncActionState state) {
          switch (state) {
            case InitialState():
              return widget.initialState;
            case SuccessState():
              return widget.successState ??
                  FunBottomSheet(
                    title: widget.successText,
                    content: FunIcon.checkmark(),
                    primaryButton: FunButton(
                      text: 'Done',
                      onTap: () => context.pop(),
                      analyticsEvent: AnalyticsEvent(
                        AmplitudeEvents.bottomsheet,
                        parameters: {
                          'bottomsheet_name': widget.analyticsName,
                          'action': 'successStateDoneClicked',
                        },
                      ),
                    ),
                  );
            case LoadingState():
              return FunBottomSheet(
                title: widget.loadingText,
                content: const CustomCircularProgressIndicator(),
              );
            case final ErrorState error:
              return FunBottomSheet(
                title: error.errorMessage ??
                    widget.errorText ??
                    'Oops, something went wrong!\nPlease try again later.',
                content: FunIcon.xmark(),
                primaryButton: FunButton(
                  text: 'Try again',
                  onTap: () => widget.cubit.onClickTryAgainAfterError(),
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.bottomsheet,
                    parameters: {
                      'bottomsheet_name': widget.analyticsName,
                      'action': 'errorStateTryAgainClicked',
                    },
                  ),
                ),
                secondaryButton: FunButton.secondary(
                  text: 'Close',
                  onTap: () => context.pop(),
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.bottomsheet,
                    parameters: {
                      'bottomsheet_name': widget.analyticsName,
                      'action': 'errorStateCloseClicked',
                    },
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
