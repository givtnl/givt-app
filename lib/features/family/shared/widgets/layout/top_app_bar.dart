import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({
    required this.title,
    this.actions = const [],
    this.leading,
    this.color,
    this.systemNavigationBarColor,
    super.key,
  });

  final String title;
  final List<Widget> actions;
  final Widget? leading;
  final Color? color;
  final Color? systemNavigationBarColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TitleMediumText.primary30(
        title,
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
