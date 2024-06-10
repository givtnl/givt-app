import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/givt_back_button.dart';
import 'package:givt_app/features/family/shared/widgets/heading_2.dart';

class HistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HistoryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: const Row(
        children: [
          Heading2(text: 'My Givts'),
          Spacer(),
        ],
      ),
      leading: const GivtBackButton(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
