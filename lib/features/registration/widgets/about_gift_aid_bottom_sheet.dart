import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';

class AboutGiftAidBottomSheet extends StatelessWidget {
  const AboutGiftAidBottomSheet({super.key});

  static void show(BuildContext context) {
    const AboutGiftAidBottomSheet()._show(context);
  }

  void _show(BuildContext context) {
    FunBottomSheet(
      title: context.l10n.giftAidAboutTitle,
      closeAction: () => Navigator.of(context).pop(),
      content: _buildContent(context),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();

  Widget _buildContent(BuildContext context) {
    final locals = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSmallText(locals.giftAidAboutWhatIs),
        const SizedBox(height: 8),
        BodyMediumText(
          locals.giftAidInfoBody,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 24),
        TitleSmallText(locals.giftAidAboutWhoCanUse),
        const SizedBox(height: 8),
        BodyMediumText(
          locals.giftAidInfo,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 24),
        TitleSmallText(locals.giftAidAboutWhyPayDifference),
        const SizedBox(height: 8),
        BodyMediumText(
          locals.giftAidBodyDisclaimer,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 24),
        TitleSmallText(locals.giftAidAboutDeclaration),
        const SizedBox(height: 8),
        BodyMediumText(
          locals.giftAidDeclarationText,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}

