import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FunScaffold extends StatelessWidget {
  const FunScaffold({
    required this.body,
    this.appBar,
    this.minimumPadding = const EdgeInsets.fromLTRB(24, 24, 24, 40),
    this.floatingActionButton,
    this.canPop = true,
    super.key,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final EdgeInsets minimumPadding;
  final Widget? floatingActionButton;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: const FamilyAppTheme().toThemeData(),
      child: GestureDetector(
        // Dismiss keyboard on tap
        onTap: () => FocusScope.of(context).unfocus(),
        child: PopScope(
          canPop: canPop,
          child: Scaffold(
            appBar: appBar,
            body: SafeArea(
              minimum: minimumPadding,
              child: body,
            ),
            floatingActionButton: floatingActionButton,
          ),
        ),
      ),
    );
  }
}