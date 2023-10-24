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
              //TODO: POEditor
              '+ Add a child profile',
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
