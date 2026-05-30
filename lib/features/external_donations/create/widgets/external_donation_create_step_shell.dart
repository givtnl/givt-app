import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class ExternalDonationCreateStepShell extends StatelessWidget {
  const ExternalDonationCreateStepShell({
    required this.title,
    required this.currentStep,
    required this.stepCount,
    required this.body,
    this.preview,
    this.bottom,
    this.onClose,
    super.key,
  });

  final String title;
  final int currentStep;
  final int stepCount;
  final Widget body;
  final Widget? preview;
  final Widget? bottom;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        title: title,
        leading: const GivtBackButtonFlat(),
        actions: [
          if (onClose != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClose,
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FunStepper(currentStep: currentStep, stepCount: stepCount),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  body,
                  if (preview != null) ...[
                    const SizedBox(height: 16),
                    preview!,
                  ],
                ],
              ),
            ),
          ),
          if (bottom != null) ...[
            const SizedBox(height: 16),
            bottom!,
          ],
        ],
      ),
    );
  }
}

class ExternalDonationStepDescription extends StatelessWidget {
  const ExternalDonationStepDescription({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return TitleMediumText(text, textAlign: TextAlign.center);
  }
}
