import 'package:flutter/material.dart';

class ChooseCategory extends StatelessWidget {
  const ChooseCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: size.height,
        width: size.width,
        child: Text('Choose Category'),
      ),
    );
  }
}
