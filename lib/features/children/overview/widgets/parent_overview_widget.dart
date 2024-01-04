import 'package:flutter/material.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/features/children/overview/widgets/parent_overview_item.dart';

class ParentOverviewWidget extends StatelessWidget {
  const ParentOverviewWidget({
    required this.profiles,
    super.key,
  });

  final List<Profile> profiles;

  static const EdgeInsets _padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Row(
        children: profiles
            .map(
              (profile) => ParentOverviewItem(profile: profile),
            )
            .toList(),
      ),
    );
  }
}
