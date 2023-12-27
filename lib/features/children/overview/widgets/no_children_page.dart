import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            text: 'Set up Family\n',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
            children: [
              TextSpan(
                text:
                    'Create your first impact group and\nexperience generosity together.',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.normal,
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
          padding: const EdgeInsets.only(top: 20, left: 35, right: 35),
          child: ElevatedButton(
            onPressed: onAddNewChildPressed,
            child: Text(
              "+ Add members",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
