import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/custom_green_elevated_button.dart';

class NoChildrenPage extends StatelessWidget {
  const NoChildrenPage({
    required this.onAddNewChildPressed,
    super.key,
  });

  final void Function() onAddNewChildPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        SvgPicture.asset(
          'assets/images/no_children.svg',
        ),
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
    );
  }
}
