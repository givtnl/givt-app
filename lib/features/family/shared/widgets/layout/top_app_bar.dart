import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/utils/utils.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({
    required this.title,
    this.actions = const [],
    this.leading,
    this.color,
    super.key,
  });

  final String title;
  final List<Widget> actions;
  final Widget? leading;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TitleMediumText.primary30(
        title,
      ),
      backgroundColor: color ?? Theme.of(context).colorScheme.onPrimary,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: color ?? Theme.of(context).colorScheme.onPrimary,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      actionsIconTheme: const IconThemeData(
        color: AppTheme.primary30,
      ),
      iconTheme: const IconThemeData(
        color: AppTheme.primary30,
      ),
      actions: actions,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leading: leading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
