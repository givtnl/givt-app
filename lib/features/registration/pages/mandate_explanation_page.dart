import 'package:flutter/material.dart';

class MandateExplanationPage extends StatelessWidget {
  const MandateExplanationPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(
      builder: (_) => const MandateExplanationPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mandate Explanation'),
      ),
      body: const Center(
        child: Text('Mandate Explanation'),
      ),
    );
  }
}
