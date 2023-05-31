import 'package:flutter/material.dart';

class SpalshPage extends StatelessWidget {
  const SpalshPage({super.key});

  static MaterialPageRoute<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const SpalshPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 100,
        ),
      ),
    );
  }
}
