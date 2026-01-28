import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';

/// A widget that displays password validation rules with live-updating
/// checkmarks as the user types their password.
class PasswordRequirementsChecklist extends StatelessWidget {
  const PasswordRequirementsChecklist({
    required this.password,
    super.key,
  });

  final String password;

  bool get _hasMinLength => password.length >= 7;
  bool get _hasCapital => password.contains(RegExp('[A-Z]'));
  bool get _hasDigit => password.contains(RegExp('[0-9]'));

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PasswordRequirementRow(
          text: locals.passwordRuleMinChars,
          isValid: _hasMinLength,
        ),
        const SizedBox(height: 4),
        _PasswordRequirementRow(
          text: locals.passwordRuleCapital,
          isValid: _hasCapital,
        ),
        const SizedBox(height: 4),
        _PasswordRequirementRow(
          text: locals.passwordRuleDigit,
          isValid: _hasDigit,
        ),
      ],
    );
  }
}

class _PasswordRequirementRow extends StatelessWidget {
  const _PasswordRequirementRow({
    required this.text,
    required this.isValid,
  });

  final String text;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.circle_outlined,
          color: isValid ? AppTheme.primary40 : AppTheme.neutralVariant60,
          size: 16,
        ),
        const SizedBox(width: 8),
        BodySmallText(
          text,
          color: isValid ? AppTheme.primary40 : AppTheme.neutralVariant60,
        ),
      ],
    );
  }
}
