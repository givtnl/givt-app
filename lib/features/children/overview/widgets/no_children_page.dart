import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';

class NoChildrenPage extends StatelessWidget {
  const NoChildrenPage({
    required this.onAddNewChildPressed,
    super.key,
  });

  final void Function() onAddNewChildPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const BodyMediumText(
              'Create your first impact group and\nexperience generosity together.',
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            familySuperheroesIcon(),
            const Spacer(),
            GivtElevatedButton(
              onTap: onAddNewChildPressed,
              text: context.l10n.plusAddMembers,
            ),
          ],
        ),
      ),
    );
  }
}
