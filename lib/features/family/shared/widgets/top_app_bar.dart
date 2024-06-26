import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/utils/utils.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({
    required this.title,
    this.actions = const [],
    this.leading,
    super.key,
  });

  final String title;
  final List<Widget> actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppTheme.primary30,
            ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.onPrimary,
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
