import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/fun_theme_legacy.dart';

/// Icon, label, value, and optional edit affordance for the mandate
/// confirmation list (Figma list item). Used by `sign_mandate_page.dart`.
class SignMandateDetailRow extends StatelessWidget {
  const SignMandateDetailRow({
    required this.label,
    required this.value,
    required this.leadingIcon,
    required this.leadingIconColor,
    required this.showEdit,
    this.onEdit,
    super.key,
  });

  final String label;
  final String value;
  final IconData leadingIcon;
  final Color leadingIconColor;
  final bool showEdit;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Center(
              child: FaIcon(
                leadingIcon,
                size: 20,
                color: leadingIconColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelMediumText(
                  label,
                  color: theme.primary20,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 4),
                BodySmallText(
                  value,
                  color: theme.primary20,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (showEdit && onEdit != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: FaIcon(
                FontAwesomeIcons.penToSquare,
                size: 20,
                color: theme.primary40,
              ),
            )
          else
            const SizedBox(width: 25),
        ],
      ),
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: FamilyAppTheme.neutralVariant95),
        ),
      ),
      child: showEdit && onEdit != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onEdit,
                child: row,
              ),
            )
          : row,
    );
  }
}
