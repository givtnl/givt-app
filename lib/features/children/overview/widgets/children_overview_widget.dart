import 'package:flutter/material.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/features/children/overview/widgets/child_overview_item.dart';

class ChildrenOverviewWidget extends StatelessWidget {
  const ChildrenOverviewWidget({
    required this.profiles,
    super.key,
  });

  final List<Profile> profiles;

  static const EdgeInsets _padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    if (profiles.length == 1) {
      return _createLayoutForSingleChild(context);
    } else if (profiles.length > 1 && profiles.length < 4) {
      return _createLayoutForTwoThreeChildren(context);
    } else {
      return _createLayoutManyChildren(context);
    }
  }

  Widget _createLayoutForSingleChild(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Row(
        children: [
          Expanded(
            child: ChildOverviewItem(profile: profiles.first),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _createLayoutForTwoThreeChildren(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Row(
        children: profiles
            .map(
              (profile) => Expanded(
                child: ChildOverviewItem(profile: profile),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _createLayoutManyChildren(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: _padding,
        child: Row(
          children: profiles
              .map(
                (profile) => SizedBox(
                  width: size.width * 0.29,
                  child: ChildOverviewItem(profile: profile),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
