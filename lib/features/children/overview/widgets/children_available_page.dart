import 'package:flutter/material.dart';
import 'package:givt_app/features/children/family_history/family_history.dart';
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
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: size.height * 0.20,
          child: ChildrenOverviewWidget(
            profiles: profiles,
          ),
        ),
        FamilyHistory(children: profiles)
      ],
    );
  }
}
