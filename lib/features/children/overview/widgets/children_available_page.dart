import 'package:flutter/material.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/features/children/overview/widgets/children_overview_widget.dart';

class ChildrenAvailablePage extends StatelessWidget {
  const ChildrenAvailablePage({
    required this.profiles,
    super.key,
  });

  final List<Profile> profiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChildrenOverviewWidget(
          profiles: profiles,
        ),

        /// HISTORY WIDGET GOES HERE
        /// FamilyHistory(children: state.profiles)
      ],
    );
  }
}
