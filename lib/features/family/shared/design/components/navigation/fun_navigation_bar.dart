import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FunNavigationBar extends StatelessWidget {
  const FunNavigationBar({
    required this.index,
    required this.onDestinationSelected,
    required this.destinations,
    super.key,
  });

  final int index;
  final void Function(int) onDestinationSelected;
  final List<Widget> destinations;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textTheme: const TextTheme(
          labelMedium: TextStyle(
            fontFamily: 'Rouna',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        colorScheme: Theme.of(context).colorScheme,
      ),
      child: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: index,
        onDestinationSelected: onDestinationSelected,
        backgroundColor: FamilyAppTheme.secondary99,
        indicatorColor: FamilyAppTheme.secondary95,
        surfaceTintColor: Colors.transparent,
        destinations: destinations,
      ),
    );
  }
}
