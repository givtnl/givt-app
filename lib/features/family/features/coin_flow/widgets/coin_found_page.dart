import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/coin_flow/widgets/coin_found.dart';
import 'package:givt_app/features/family/features/coin_flow/widgets/search_coin_animated_widget.dart';

class CoinFoundPage extends StatelessWidget {
  const CoinFoundPage({super.key,});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(left: 50, right: 50, top: 150),
              child: Column(
                children: [
                  Text(
                    'Found it!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF3B3240),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Let's assign the coin",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF3B3240),
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: SearchCoinAnimatedWidget(),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: CoinFound(),
            ),
          ),
        ],
      ),
    );
  }
}
