import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/bloc/fun_bottom_sheet_with_async_action_cubit.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/app_theme.dart';

class USTerminateAccountBottomSheet extends StatefulWidget {
  const USTerminateAccountBottomSheet({
    required this.asyncCubit,
    super.key,
  });

  final FunBottomSheetWithAsyncActionCubit asyncCubit;

  @override
  State<USTerminateAccountBottomSheet> createState() =>
      _USTerminateAccountBottomSheetState();
}

class _USTerminateAccountBottomSheetState
    extends State<USTerminateAccountBottomSheet> {
  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return FunBottomSheet(
      closeAction: () => Navigator.of(context).pop(),
      title: 'Terminate Account',
      primaryButton: FunButton.destructive(
        onTap: () {
          widget.asyncCubit.doAsyncAction(() async {
            // Add termination logic here
            await Future.delayed(const Duration(seconds: 2));
          });
        },
        text: 'Terminate account',
        isDisabled: !isButtonEnabled,
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.terminateAccountStarted,
        ),
      ),
      secondaryButton: FunButton.secondary(
        onTap: () => Navigator.of(context).pop(),
        text: locals.cancel,
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.terminateAccountCancelled,
        ),
      ),
      content: Column(
        children: [
          FunIcon.exclamation(
            circleColor: FamilyAppTheme.error90,
          ),
          const SizedBox(height: 16),
          const BodyMediumText(
            'We’re sorry to see you go!\nAfter terminating your account, we cannot recover it for you.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                semanticLabel: 'saveDataCheckbox',
                value: isButtonEnabled,
                onChanged: (bool? value) {
                  setState(() {
                    isButtonEnabled = value ?? false;
                  });
                },
                side: const BorderSide(
                  color: AppTheme.inputFieldBorderEnabled,
                  width: 2,
                ),
              ),
              const Flexible(
                  child:
                      LabelMediumText('Yes, I want to terminate my account')),
            ],
          ),
        ],
      ),
    );
  }
}
