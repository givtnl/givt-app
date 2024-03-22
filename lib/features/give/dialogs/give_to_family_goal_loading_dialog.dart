import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class GiveToFamilyGoalLoadingDialog extends StatelessWidget {
  const GiveToFamilyGoalLoadingDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocListener<GiveBloc, GiveState>(
      listener: (context, state) {
        if (state.status == GiveStatus.processed ||
            state.status == GiveStatus.error) {
          context.pop();
        }
      },
      child: SimpleDialog(
        backgroundColor: AppTheme.givtGraycece,
        children: [
          SizedBox.square(
            dimension: size.width * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator.adaptive(),
                const SizedBox(height: 16),
                Text(
                  context.l10n.loadingTitle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
