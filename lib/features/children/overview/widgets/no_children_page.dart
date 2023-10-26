import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/l10n/l10n.dart';

class NoChildrenPage extends StatelessWidget {
  const NoChildrenPage({
    required this.onAddNewChildPressed,
    super.key,
  });

  final void Function() onAddNewChildPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/no_children.svg',
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 35, right: 35),
          child: ElevatedButton(
            onPressed: onAddNewChildPressed,
            child: Text(
              context.l10n.childrenAddChildProfile,
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
