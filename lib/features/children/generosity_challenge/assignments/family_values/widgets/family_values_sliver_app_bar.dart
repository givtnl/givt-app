import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

class FamilyValuesSliverAppBar extends StatelessWidget {
  const FamilyValuesSliverAppBar({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      primary: false,
      backgroundColor: Colors.white,
      surfaceTintColor: AppTheme.primary90,
      automaticallyImplyLeading: false,
      title: child,
    );
  }
}
