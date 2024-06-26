import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoGoalsWidget extends StatelessWidget {
  const NoGoalsWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/family/images/family_superheroes.svg'),
          const SizedBox(height: 20),
          Text(
            'Your Family Group and other\ngroups will appear here',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
