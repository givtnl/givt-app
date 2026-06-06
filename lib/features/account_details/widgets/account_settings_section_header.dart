import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

class AccountSettingsSectionHeader extends StatelessWidget {
  const AccountSettingsSectionHeader({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: BodySmallText(
          title,
          color: FunTheme.of(context).primary30,
        ),
      ),
    );
  }
}
