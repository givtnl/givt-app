import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/widgets/errors/unrecoverable_error.dart';
import 'package:givt_app/utils/snack_bar_helper.dart';

class BaseStateConsumer<T extends StateStreamable<S>,
    S extends BaseState<dynamic>> extends StatelessWidget {
  const BaseStateConsumer({
    required this.onData,
    required this.bloc,
    super.key,
    this.onInitial,
    this.onCustom,
    this.onLoading,
  });

  final T bloc;
  final Widget Function(BuildContext context)? onInitial;
  final Widget Function(BuildContext context)? onLoading;
  final Widget Function(BuildContext context, dynamic uiModel) onData;
  final void Function(BuildContext context, dynamic object)? onCustom;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<T, S>(
      bloc: bloc,
      listener: (context, state) {
        if (state is CustomState) {
          onCustom?.call(context, state.custom);
        } else if (state is SnackbarState) {
          SnackBarHelper.showMessage(
            context,
            text: state.text,
            isError: state.isError,
          );
        }
      },
      listenWhen: (previousState, currentState) {
        return currentState is CustomState || currentState is SnackbarState;
      },
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
        } else if (state is DataState) {
          return onData(context, state.data);
        } else {
          return const UnrecoverableError();
        }
      },
    );
  }
}
