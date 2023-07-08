import 'package:flutter/material.dart';

class BottomSheetLayout extends StatelessWidget {
  const BottomSheetLayout({
    required this.child,
    this.title,
    super.key,
  });

  final Widget child;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Scaffold(
          appBar: AppBar(
            title: title,
            leading: const BackButton(),
          ),
          body: child,
        ),
      ),
    );
  }
}
