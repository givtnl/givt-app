import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_secondary_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class CancelAllowanceDialog extends StatelessWidget {
  const CancelAllowanceDialog({
    required this.onCancel,
    super.key,
  });
  final VoidCallback onCancel;
  @override
  Widget build(BuildContext context) {
    final theme = const FamilyAppTheme().toThemeData();
    return Theme(
      data: theme,
      child: Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              trashAvatarIcon(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.width * 0.35,
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to cancel the Recurring Amount?',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Text(
                "This will interrupt your child's giving journey.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GivtElevatedButton(
                    onTap: () => {
                      onCancel.call(),
                      context
                        ..pop()
                        ..pop(),
                    },
                    text: 'Yes, cancel',
                    leftIcon: FontAwesomeIcons.xmark,
                    backgroundColor: AppTheme.error80,
                    borderColor: AppTheme.error30,
                  ),
                  const SizedBox(height: 8),
                  GivtElevatedSecondaryButton(
                    onTap: () => context.pop(),
                    text: 'No, go back',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
