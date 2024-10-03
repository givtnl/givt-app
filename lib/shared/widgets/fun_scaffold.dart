import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FunScaffold extends StatelessWidget {
  const FunScaffold({
    required this.body,
    this.appBar,
    this.minimumPadding = const EdgeInsets.fromLTRB(24, 24, 24, 40),
    this.canPop = true,
    this.safeAreaBottom = true,
    this.withSafeArea = true,
    this.floatingActionButton,
    this.backgroundColor = Colors.white,
    super.key,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final EdgeInsets minimumPadding;
  final bool canPop;
  final bool safeAreaBottom;
  final bool withSafeArea;
  final Color backgroundColor;
  final FunButton? floatingActionButton;

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
            backgroundColor: backgroundColor,
            appBar: appBar,
            body: withSafeArea
                ? SafeArea(
                    minimum: minimumPadding,
                    bottom: safeAreaBottom,
                    child: body,
                  )
                : body,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: floatingActionButton,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        ),
      ),
    );
  }
}
