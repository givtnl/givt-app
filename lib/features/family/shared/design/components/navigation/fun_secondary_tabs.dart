import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FunSecondaryTabs extends StatelessWidget {
  const FunSecondaryTabs({
    required this.tabs,
    required this.tabContents,
    this.onTap,
    super.key,
  });

  final List<Tab> tabs;
  final List<Widget> tabContents;
  final Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar.secondary(
            onTap: onTap,
            tabs: tabs,
            unselectedLabelColor: FamilyAppTheme.neutral70,
            labelColor: FamilyAppTheme.primary70,
            dividerColor: FamilyAppTheme.neutral80,
            indicatorColor: FamilyAppTheme.primary70,
          ),
          Expanded(
            child: TabBarView(
              children: tabContents.map((content) {
                return SingleChildScrollView(
                  child: content,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
