import 'package:flutter/material.dart';

class ChildrenLoadingPage extends StatelessWidget {
  const ChildrenLoadingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
