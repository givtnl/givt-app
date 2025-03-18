import 'package:flutter/material.dart';

class FunSecondaryTabs extends StatelessWidget {
  const FunSecondaryTabs({
    required this.tabs,
    required this.tabContents,
    super.key,
  });

  final List<Tab> tabs;
  final List<Widget> tabContents;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length, // Number of tabs
      child: Column(
        children: [
          TabBar(
            tabs: tabs,
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
