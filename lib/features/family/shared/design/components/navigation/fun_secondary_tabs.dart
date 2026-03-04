import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';

class FunSecondaryTabs extends StatelessWidget {
  const FunSecondaryTabs({
    required this.tabs,
    required this.tabContents,
    this.controller,
    this.onTap,
    super.key,
  });

  final List<Tab> tabs;
  final List<Widget> tabContents;
  final TabController? controller;
  final Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar.secondary(
            controller: controller,
            onTap: onTap,
            tabs: tabs,
            unselectedLabelColor: FunTheme.of(context).neutral70,
            labelColor: FunTheme.of(context).primary70,
            dividerColor: FunTheme.of(context).neutral80,
            indicatorColor: FunTheme.of(context).primary70,
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
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
