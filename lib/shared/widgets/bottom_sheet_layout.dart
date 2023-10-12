import 'package:flutter/material.dart';

class BottomSheetLayout extends StatelessWidget {
  const BottomSheetLayout({
    required this.child,
    this.onBackPressed,
    this.title,
    this.bottomSheet,
    this.backgroundColor,
    this.backButtonColor,
    super.key,
  });

  final Widget child;
  final Widget? title;
  final Widget? bottomSheet;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? backButtonColor;

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
              color: backButtonColor,
            ),
            backgroundColor: backgroundColor ?? Colors.transparent,
          ),
          bottomSheet: bottomSheet,
          backgroundColor: backgroundColor ?? Colors.transparent,
          body: child,
        ),
      ),
    );
  }
}
