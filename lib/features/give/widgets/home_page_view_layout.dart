import 'package:flutter/material.dart';

class HomePageViewLayout extends StatelessWidget {
  const HomePageViewLayout({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.only(
        right: 8,
        left: 8,
        bottom: 8,
        top: 15,
      ),
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: child,
      ),
    );
  }
}
