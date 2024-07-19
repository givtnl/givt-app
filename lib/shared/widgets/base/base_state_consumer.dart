import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/widgets/errors/unrecoverable_error.dart';
import 'package:givt_app/utils/snack_bar_helper.dart';

class BaseStateConsumer<E, K> extends StatelessWidget {
  const BaseStateConsumer({
    required this.cubit,
    super.key,
    this.onData,
    this.onInitial,
    this.onCustom,
    this.onLoading,
  });

  final Cubit<BaseState<E, K>> cubit;

  // for displaying the widget in an initial state
  // not every widget has an initial state so this is optional
  // but if you call it without defining it it will display an error
  final Widget Function(BuildContext context)? onInitial;

  // for displaying the widget in a loading state
  final Widget Function(BuildContext context)? onLoading;

  // for building UI
  final Widget Function(BuildContext context, E uiModel)? onData;

  // for (one-off) methods only, not for building UI!
  // so for example showing a dialog, a bottom sheet, etc.
  final void Function(BuildContext context, K custom)? onCustom;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Cubit<BaseState<E, K>>, BaseState<E, K>>(
      bloc: cubit,
      listener: (context, state) {
        if (state is CustomState<E, K>) {
          onCustom?.call(context, state.custom);
        } else if (state is SnackbarState<E, K>) {
          SnackBarHelper.showMessage(
            context,
            text: state.text,
            isError: state.isError,
          );
        }
      },
      // these states will only be fired in the listener and not in the builder
      // so they will not trigger a rebuild of the widget (for efficiency)
      listenWhen: (previousState, currentState) {
        return currentState is CustomState || currentState is SnackbarState;
      },
      // these states will trigger a rebuild of the widget
      buildWhen: (previousState, currentState) {
        return currentState is InitialState ||
            currentState is DataState ||
            currentState is LoadingState;
      },
      builder: (context, state) {
        if (state is InitialState) {
          return onInitial?.call(context) ?? const UnrecoverableError();
        } else if (state is LoadingState) {
          return onLoading?.call(context) ?? const CircularProgressIndicator();
        } else if (state is DataState<E, K>) {
          return onData?.call(context, state.data) ??
              const UnrecoverableError();
        } else {
          return const UnrecoverableError();
        }
      },
    );
  }
}
