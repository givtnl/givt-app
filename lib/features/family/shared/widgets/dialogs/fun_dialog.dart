import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/models/fun_dialog_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class FunDialog extends StatelessWidget {
  const FunDialog({
    required this.uiModel,
    super.key,
    this.image,
    this.onClickClose,
    this.onClickPrimary,
    this.onClickSecondary,
  });

  final FunDialogUIModel uiModel;
  final Widget? image;
  final VoidCallback? onClickClose;
  final VoidCallback? onClickPrimary;
  final VoidCallback? onClickSecondary;

  static Future<void> show(
    BuildContext context, {
    required FunDialogUIModel uiModel,
    Widget? image,
    VoidCallback? onClickClose,
    VoidCallback? onClickPrimary,
    VoidCallback? onClickSecondary,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => FunDialog(
        uiModel: uiModel,
        image: image,
        onClickClose: onClickClose,
        onClickPrimary: onClickPrimary,
        onClickSecondary: onClickSecondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = const FamilyAppTheme().toThemeData();
    return Theme(
      data: theme,
      child: Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        child: _layout(theme, context),
      ),
    );
  }

  Stack _layout(ThemeData theme, BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            20,
            24,
            24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (image != null) image!,
              const SizedBox(height: 16),
              if (uiModel.title != null)
                TitleMediumText(
                  uiModel.title!,
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 8),
              if (uiModel.description != null)
                BodyMediumText(
                  uiModel.description!,
                  textAlign: TextAlign.center,
                ),
              const SizedBox(
                height: 16,
              ),
              if (uiModel.primaryButtonText != null)
                FunButton(
                  onTap: () {
                    context.pop();
                    onClickPrimary?.call();
                  },
                  text: uiModel.primaryButtonText!,
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.funDialogAction,
                    parameters: {
                      'action': 'primary',
                      'text': uiModel.primaryButtonText,
                    },
                  ),
                ),
              if (uiModel.secondaryButtonText != null &&
                  uiModel.primaryButtonText != null)
                const SizedBox(height: 8),
              if (uiModel.secondaryButtonText != null)
                FunButton.secondary(
                  onTap: () {
                    context.pop();
                    onClickSecondary?.call();
                  },
                  text: uiModel.secondaryButtonText!,
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.funDialogAction,
                    parameters: {
                      'action': 'secondary',
                      'text': uiModel.secondaryButtonText,
                    },
                  ),
                ),
            ],
          ),
        ),
        if (uiModel.showCloseButton)
          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              icon: const FaIcon(
                  semanticLabel: 'xmark',
                  FontAwesomeIcons.xmark),
              onPressed: () {
                SystemSound.play(SystemSoundType.click);
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.funDialogAction,
                  eventProperties: {
                    'action': 'close',
                  },
                );
                context.pop();
                onClickClose?.call();
              },
            ),
          ),
      ],
    );
  }
}
