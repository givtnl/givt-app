import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_preview_row.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

/// Bottom preview panel (Figma History Item) for create-flow steps.
class ExternalDonationCreatePreviewPanel extends StatelessWidget {
  const ExternalDonationCreatePreviewPanel({
    required this.rows,
    this.moreRecordsLabel,
    this.showSectionTitle = true,
    super.key,
  });

  final List<ExternalDonationCreatePreviewRow> rows;
  final String? moreRecordsLabel;
  final bool showSectionTitle;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }

    final locals = context.l10n;
    final theme = FunTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showSectionTitle) ...[
          BodySmallText(
            locals.externalDonationsCreatePreviewTitle,
            color: theme.neutralVariant40,
          ),
          const SizedBox(height: 8),
        ],
        ...rows.map(
          (row) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _PreviewHistoryItem(row: row),
          ),
        ),
        if (moreRecordsLabel != null)
          BodySmallText(
            moreRecordsLabel!,
            color: theme.neutralVariant40,
          ),
      ],
    );
  }
}

class _PreviewHistoryItem extends StatelessWidget {
  const _PreviewHistoryItem({required this.row});

  final ExternalDonationCreatePreviewRow row;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final locals = context.l10n;
    final statusBackgroundColor = row.isUpcoming
        ? theme.secondary95
        : theme.primary95;
    final statusIconColor = row.isUpcoming
        ? theme.secondary40
        : theme.primary30;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.neutral98,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.neutralVariant95),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: _statusIcon(statusBackgroundColor, statusIconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LabelMediumText(
                    row.organisationName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (row.primarySubtitle != null) ...[
                    const SizedBox(height: 4),
                    BodySmallText(
                      row.primarySubtitle!,
                      color: theme.neutral30,
                    ),
                  ],
                  if (row.dateLabel != null) ...[
                    const SizedBox(height: 2),
                    LabelSmallText(
                      row.dateLabel!,
                      color: theme.neutralVariant50,
                    ),
                  ],
                  if (row.secondarySubtitle != null) ...[
                    const SizedBox(height: 2),
                    BodySmallText(
                      row.secondarySubtitle!,
                      color: theme.neutral30,
                    ),
                  ],
                  if (row.isUpcoming || row.isCompleted) ...[
                    const SizedBox(height: 2),
                    BodySmallText(
                      row.isUpcoming
                          ? locals.recurringDonationsDetailStatusUpcoming
                          : locals.recurringDonationsDetailStatusCompleted,
                      color: statusIconColor,
                    ),
                  ],
                ],
              ),
            ),
            if (row.typeTagLabel != null || row.amountLabel != null) ...[
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (row.typeTagLabel != null)
                    FunTag(
                      text: row.typeTagLabel!,
                      variant: FunTagVariant.accent,
                      iconData: FontAwesomeIcons.arrowsRotate,
                      iconSize: 12,
                      margin: EdgeInsets.zero,
                    ),
                  if (row.amountLabel != null) ...[
                    if (row.typeTagLabel != null) const SizedBox(height: 4),
                    LabelMediumText(
                      row.amountLabel!,
                      color: theme.primary40,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusIcon(
    Color statusBackgroundColor,
    Color statusIconColor,
  ) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: statusBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: FaIcon(
        row.isUpcoming ? FontAwesomeIcons.solidClock : FontAwesomeIcons.check,
        size: 20,
        color: statusIconColor,
      ),
    );
  }
}
