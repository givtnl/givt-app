import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';

class FoundNfcAnimation extends StatelessWidget {
  const FoundNfcAnimation({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Found it!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 160,
            padding: const EdgeInsets.only(top: 16, bottom: 32),
            child: SvgPicture.asset('assets/family/images/coin_found.svg'),
          ),
          const Visibility(
            visible: false,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: FunButton(
              isDisabled: true,
              onTap: null,
              text: '',
            ),
          ),
        ],
      ),
    );
  }
}
