import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FamilyScaffold extends StatelessWidget {
  const FamilyScaffold({
    required this.body,
    this.appBar,
    this.minimumPadding = const EdgeInsets.fromLTRB(24, 24, 24, 40),
    this.floatingActionButton,
    super.key,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final EdgeInsets minimumPadding;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: const FamilyAppTheme().toThemeData(),
      child: GestureDetector(
        // Dismiss keyboard on tap
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: appBar,
          body: SafeArea(
            minimum: minimumPadding,
            child: body,
          ),
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }
}
