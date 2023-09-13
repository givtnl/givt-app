import 'package:flutter/material.dart';

class BottomSheetLayout extends StatelessWidget {
  const BottomSheetLayout({
    required this.child,
    this.onBackPressed,
    this.title,
    this.bottomSheet,
    super.key,
  });

  final Widget child;
  final Widget? title;
  final Widget? bottomSheet;
  final VoidCallback? onBackPressed;

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
            leading: BackButton(
              onPressed: onBackPressed,
            ),
          ),
          bottomSheet: bottomSheet,
          body: child,
        ),
      ),
    );
  }
}
