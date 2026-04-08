import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/organisation_goals.dart';
import 'package:go_router/go_router.dart';

/// FUN bottom sheet to pick additional general (QR) goals for the For You flow.
class ForYouMoreGeneralGoalsSheet extends StatefulWidget {
  const ForYouMoreGeneralGoalsSheet({
    required this.availableGoals,
    required this.onConfirm,
    super.key,
  });

  final List<OrganisationQrCode> availableGoals;
  final void Function(List<OrganisationQrCode> selected) onConfirm;

  static Future<void> show({
    required BuildContext context,
    required List<OrganisationQrCode> availableGoals,
    required void Function(List<OrganisationQrCode> selected) onConfirm,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => ForYouMoreGeneralGoalsSheet(
        availableGoals: availableGoals,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<ForYouMoreGeneralGoalsSheet> createState() =>
      _ForYouMoreGeneralGoalsSheetState();
}

class _ForYouMoreGeneralGoalsSheetState
    extends State<ForYouMoreGeneralGoalsSheet> {
  final Set<String> _selectedMediumIds = <String>{};

  void _toggle(String mediumId) {
    setState(() {
      if (_selectedMediumIds.contains(mediumId)) {
        _selectedMediumIds.remove(mediumId);
      } else {
        _selectedMediumIds.add(mediumId);
      }
    });
  }

  void _onPrimaryPressed() {
    final selected = <OrganisationQrCode>[];
    for (final qr in widget.availableGoals) {
      if (_selectedMediumIds.contains(qr.mediumId)) {
        selected.add(qr);
      }
    }
    widget.onConfirm(selected);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final l10n = context.l10n;
    final count = _selectedMediumIds.length;

    return FunBottomSheet(
      title: l10n.forYouMoreGeneralGoalsSheetTitle,
      titleColor: theme.primary30,
      closeAction: () => context.pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          BodyMediumText(
            l10n.forYouMoreGeneralGoalsSheetSubtitle,
            textAlign: TextAlign.center,
            color: theme.primary30,
          ),
          const SizedBox(height: 16),
          ...List.generate(widget.availableGoals.length, (index) {
            final qr = widget.availableGoals[index];
            final isSelected = _selectedMediumIds.contains(qr.mediumId);
            final label = qr.allocationName.trim();
            final isLast = index == widget.availableGoals.length - 1;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _toggle(qr.mediumId),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: LabelMediumText(
                              label,
                              color: theme.primary30,
                            ),
                          ),
                          FunIcon(
                            iconData: isSelected
                                ? FontAwesomeIcons.check
                                : FontAwesomeIcons.plus,
                            padding: EdgeInsets.zero,
                            circleColor: Colors.transparent,
                            circleSize: 18,
                            iconSize: 18,
                            iconColor: theme.primary30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    color: theme.neutralVariant90,
                  ),
              ],
            );
          }),
        ],
      ),
      primaryButton: FunButton(
        text: count == 0
            ? l10n.forYouMoreGeneralGoalsAddPlaceholder
            : count == 1
                ? l10n.forYouMoreGeneralGoalsAddOne
                : l10n.forYouMoreGeneralGoalsAddMany(count),
        isDisabled: count == 0,
        analyticsEvent: AnalyticsEventName.forYouGivingMoreGoalsConfirmTapped
            .toEvent(),
        onTap: _onPrimaryPressed,
      ),
    );
  }
}
