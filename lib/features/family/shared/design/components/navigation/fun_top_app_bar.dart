import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';

/// Visual variant of the app bar; used to resolve background color when
/// the color parameter is not set.
enum FunTopAppBarVariant {
  primary99,
  white,
}

class FunTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FunTopAppBar({
    this.title,
    this.actions = const [],
    this.leading,
    this.color,
    this.variant,
    this.titleColor,
    this.systemNavigationBarColor,
    this.overridePreferredSize,
    super.key,
  });

  final String? title;
  final List<Widget> actions;
  final Widget? leading;
  final Color? color;
  final FunTopAppBarVariant? variant;
  final Color? titleColor;
  final Color? systemNavigationBarColor;
  final Size? overridePreferredSize;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final resolvedBackgroundColor = color ??
        (variant == FunTopAppBarVariant.primary99
            ? theme.primary99
            : variant == FunTopAppBarVariant.white
                ? Colors.white
                : Theme.of(context).colorScheme.onPrimary);
    final resolvedTitleColor = titleColor ?? theme.primary20;

    return AppBar(
      title: title == null
          ? null
          : TitleMediumText(
              title!,
              color: resolvedTitleColor,
            ),
      backgroundColor: resolvedBackgroundColor,
      actionsIconTheme: IconThemeData(
        color: resolvedTitleColor,
      ),
      iconTheme: IconThemeData(
        color: resolvedTitleColor,
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
  Size get preferredSize =>
      overridePreferredSize ?? const Size.fromHeight(kToolbarHeight);
}
