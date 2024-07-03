import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/app_theme.dart';

class NoChildrenPage extends StatelessWidget {
  const NoChildrenPage({
    required this.onAddNewChildPressed,
    super.key,
  });

  final void Function() onAddNewChildPressed;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '${context.l10n.setUpFamily}\n',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
              children: [
                TextSpan(
                  text:
                      'Create your first impact group and\nexperience generosity together.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          ),
          familySuperheroesIcon(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 35,
              right: 35,
              bottom: 12,
            ),
            child: CustomGreenElevatedButton(
              onPressed: onAddNewChildPressed,
              title: context.l10n.plusAddMembers,
            ),
          ),
        ],
      ),
    );
  }
}
