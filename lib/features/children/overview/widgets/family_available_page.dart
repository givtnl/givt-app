import 'package:flutter/material.dart';
import 'package:givt_app/features/children/family_history/family_history.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/features/children/overview/widgets/children_overview_widget.dart';
import 'package:givt_app/features/children/overview/widgets/parent_overview_widget.dart';

class FamilyAvailablePage extends StatelessWidget {
  const FamilyAvailablePage({
    required this.profiles,
    super.key,
  });

  final List<Profile> profiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ParentOverviewWidget(
          profiles: profiles.where((p) => p.type == 'Parent').toList(),
        ),
        const SizedBox(height: 20),
        ChildrenOverviewWidget(
          profiles: profiles.where((p) => p.type == 'Child').toList(),
        ),
        const SizedBox(height: 32),
        const Expanded(
          child: FamilyHistory(),
        )
      ],
    );
  }
}
