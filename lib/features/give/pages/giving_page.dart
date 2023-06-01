import 'package:flutter/material.dart';

class GivingScreen extends StatelessWidget {
  const GivingScreen({super.key});

  static MaterialPageRoute<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const GivingScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giving'),
      ),
      body: Center(
        child: Text('Giving'),
      ),
    );
  }
}
