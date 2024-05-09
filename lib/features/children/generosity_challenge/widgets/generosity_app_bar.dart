import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/utils/app_theme.dart';

class GenerosityAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GenerosityAppBar({
    required this.title,
    required this.leading,
    this.actions,
    super.key,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.givtGreen40,
              fontFamily: 'Rouna',
              fontWeight: FontWeight.w700,
            ),
      ),
      leading: leading,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppTheme.givtLightBackgroundGreen,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      backgroundColor: AppTheme.givtLightBackgroundGreen,
      elevation: 0,
      centerTitle: true,
      actions: actions,
      automaticallyImplyLeading: leading != null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
