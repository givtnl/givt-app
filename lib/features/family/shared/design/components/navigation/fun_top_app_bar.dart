import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FunTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FunTopAppBar({
    required this.title,
    this.actions = const [],
    this.leading,
    this.color,
    this.titleColor,
    this.systemNavigationBarColor,
    this.overridePreferredSize,
    super.key,
  });

  factory FunTopAppBar.primary99({
    required String title,
    List<Widget> actions = const [],
    Widget? leading,
    Color? systemNavigationBarColor,
  }) =>
      FunTopAppBar(
        title: title,
        actions: actions,
        leading: leading,
        color: FamilyAppTheme.primary99,
        systemNavigationBarColor: systemNavigationBarColor,
      );

  factory FunTopAppBar.white({
    String? title,
    List<Widget> actions = const [],
    Widget? leading,
    Color? systemNavigationBarColor,
  }) =>
      FunTopAppBar(
        title: title,
        actions: actions,
        leading: leading,
        color: Colors.white,
        systemNavigationBarColor: systemNavigationBarColor,
      );

  final String? title;
  final List<Widget> actions;
  final Widget? leading;
  final Color? color;
  final Color? titleColor;
  final Color? systemNavigationBarColor;
  final Size? overridePreferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title == null
          ? null
          : TitleMediumText(
              title!,
              color: titleColor ?? FamilyAppTheme.primary30,
            ),
      backgroundColor: color ?? Theme.of(context).colorScheme.onPrimary,
      actionsIconTheme: const IconThemeData(
        color: FamilyAppTheme.primary30,
      ),
      iconTheme: const IconThemeData(
        color: FamilyAppTheme.primary30,
      ),
      actions: actions,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leading: leading,
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: systemNavigationBarColor ?? Colors.white,
      ),
    );
  }

  @override
  Size get preferredSize => overridePreferredSize ?? const Size.fromHeight(kToolbarHeight);
}
