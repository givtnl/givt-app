import 'package:flutter/material.dart';

class VPCIntroItemFamily extends StatelessWidget {
  const VPCIntroItemFamily({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          const Positioned.fill(
            child: Text(
              'We’ve made it easy for your children to take part in giving.\n\nIf you have multiple children, set up all your child profiles now. If you come out of the app you will need to give verifiable permission again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: Color(0xFF184869),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Image.asset(
                'assets/images/vpc_intro_family.png',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
