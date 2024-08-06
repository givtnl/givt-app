import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_cubit.dart';
import 'package:givt_app/utils/utils.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    required this.index,
    required this.onDestinationSelected,
    super.key,
  });
  final int index;
  final void Function(int) onDestinationSelected;
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
        backgroundColor: AppTheme.secondary99,
        indicatorColor: AppTheme.secondary95,
        surfaceTintColor: Colors.transparent,
        destinations: NavigationDestinationData.values
            .map(
              (destination) => NavigationDestination(
                icon: SvgPicture.asset(destination.iconPath),
                label: destination.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
