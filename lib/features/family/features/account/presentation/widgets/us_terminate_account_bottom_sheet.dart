import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/bloc/fun_bottom_sheet_with_async_action_cubit.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/utils.dart';

class USTerminateAccountBottomSheet extends StatefulWidget {
  const USTerminateAccountBottomSheet({
    required this.asyncCubit,
    required this.email,
    super.key,
    this.onSuccess,
  });

  final String email;
  final FunBottomSheetWithAsyncActionCubit asyncCubit;
  final VoidCallback? onSuccess;

  @override
  State<USTerminateAccountBottomSheet> createState() =>
      _USTerminateAccountBottomSheetState();
}

class _USTerminateAccountBottomSheetState
    extends State<USTerminateAccountBottomSheet> {
  bool isCheckboxChecked = false;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return FunBottomSheet(
      closeAction: () => Navigator.of(context).pop(),
      title: locals.unregisterTitle,
      primaryButton: FunButton.destructive(
        onTap: () {
          widget.asyncCubit.doAsyncAction(() async {
            await getIt<AuthRepository>().unregisterUser(
              email: widget.email,
            );
            widget.onSuccess?.call();
          });
        },
        text: locals.unregisterPrimaryBtnText,
        isDisabled: !isCheckboxChecked,
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
          BodyMediumText(
            locals.unregisterDescription,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                semanticLabel: 'terminateAccountCheckbox',
                value: isCheckboxChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isCheckboxChecked = value ?? false;
                  });

                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.terminateAccountCheckboxChecked,
                    eventProperties: {
                      'isChecked': value ?? false,
                    },
                  );
                },
                side: const BorderSide(
                  color: AppTheme.inputFieldBorderEnabled,
                  width: 2,
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () => setState(() {
                    isCheckboxChecked = !isCheckboxChecked;

                    AnalyticsHelper.logEvent(
                      eventName:
                          AmplitudeEvents.terminateAccountCheckboxChecked,
                      eventProperties: {
                        'isChecked': isCheckboxChecked,
                      },
                    );
                  }),
                  child: LabelMediumText(
                    locals.unregisterCheckboxText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
