import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

enum _AddDonationOption { giveThroughGivt, addExternal }

class AddDonationBottomSheet extends StatefulWidget {
  const AddDonationBottomSheet({
    required this.onGiveThroughGivt,
    required this.onAddExternalDonation,
    super.key,
  });

  final VoidCallback onGiveThroughGivt;
  final VoidCallback onAddExternalDonation;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onGiveThroughGivt,
    required VoidCallback onAddExternalDonation,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      builder: (_) => AddDonationBottomSheet(
        onGiveThroughGivt: onGiveThroughGivt,
        onAddExternalDonation: onAddExternalDonation,
      ),
    );
  }

  @override
  State<AddDonationBottomSheet> createState() => _AddDonationBottomSheetState();
}

class _AddDonationBottomSheetState extends State<AddDonationBottomSheet> {
  _AddDonationOption? _selected;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final theme = FunTheme.of(context);

    return FunBottomSheet(
      title: locals.personalSummaryAddDonationSheetTitle,
      titleColor: theme.secondary30,
      closeAction: () => Navigator.of(context).pop(),
      content: Column(
        children: [
          const SizedBox(height: 16),
          _AddDonationOptionRow(
            title: locals.personalSummaryGiveThroughGivt,
            subtitle: locals.personalSummaryGiveThroughGivtSubtitle,
            isSelected: _selected == _AddDonationOption.giveThroughGivt,
            onTap: () => setState(
              () => _selected = _AddDonationOption.giveThroughGivt,
            ),
          ),
          _AddDonationOptionRow(
            title: locals.personalSummaryAddExternalDonation,
            subtitle: locals.personalSummaryAddExternalDonationSubtitle,
            isSelected: _selected == _AddDonationOption.addExternal,
            onTap: () => setState(
              () => _selected = _AddDonationOption.addExternal,
            ),
            showDivider: false,
          ),
        ],
      ),
      primaryButton: FunButton(
        text: locals.buttonContinue,
        isDisabled: _selected == null,
        analyticsEvent: AnalyticsEventName
            .personalSummaryAddDonationContinueClicked
            .toEvent(
          parameters: {
            'givt_donation': _selected == _AddDonationOption.giveThroughGivt,
            'external_donation': _selected == _AddDonationOption.addExternal,
          },
        ),
        onTap: _selected == null
            ? null
            : () {
                Navigator.of(context).pop();
                switch (_selected!) {
                  case _AddDonationOption.giveThroughGivt:
                    widget.onGiveThroughGivt();
                  case _AddDonationOption.addExternal:
                    widget.onAddExternalDonation();
                }
              },
      ),
    );
  }
}

class _AddDonationOptionRow extends StatelessWidget {
  const _AddDonationOptionRow({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.showDivider = true,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: showDivider
                    ? theme.neutralVariant95
                    : Colors.transparent,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelMediumText(title, color: theme.primary20),
                    const SizedBox(height: 4),
                    BodySmallText(subtitle, color: theme.neutral50),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FaIcon(
                isSelected
                    ? FontAwesomeIcons.solidCircleCheck
                    : FontAwesomeIcons.circle,
                size: 20,
                color: isSelected
                    ? theme.primary40
                    : theme.primary30.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
