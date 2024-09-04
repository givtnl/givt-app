import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_top_app_bar.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({required this.success, super.key});
  
  final bool success;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FunTopAppBar(
        title: 'Result',
      ),
      body: Center(
        child: success
            ? const Text('Success Placeholder')
            : const Text('Failure Placeholder'),
      ),
    );
  }
}
