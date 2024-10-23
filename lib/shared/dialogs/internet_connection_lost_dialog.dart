import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/internet_connection/internet_connection_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/warning_dialog.dart';
import 'package:go_router/go_router.dart';

class InternetConnectionLostDialog {
  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) =>
          BlocListener<InternetConnectionCubit, InternetConnectionState>(
        bloc: getIt<InternetConnectionCubit>(),
        listener: (context, state) {
          if (state is InternetConnectionLive) {
            context.pop();
          }
        },
        child: WarningDialog(
          title: context.l10n.noInternetConnectionTitle,
          content:
              "Oops! It looks like you're not connected to the internet. Some features might not work as expected. Please come back when you have a connection.",
          onConfirm: () => context.pop(),
        ),
      ),
    );
  }
}
