import 'package:flutter/material.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/cached_members/widgets/cached_member_overview_tile.dart';

class CachedMemberOverviewWidget extends StatelessWidget {
  const CachedMemberOverviewWidget({
    required this.members,
    super.key,
  });

  final List<Member> members;

  static const EdgeInsets _padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    if (members.length == 1) {
      return _createLayoutForSingleProfile(context);
    } else if (members.length > 1 && members.length < 4) {
      return _createLayoutForTwoThreeProfiles(context);
    } else {
      return _createLayoutManyProfiles(context);
    }
  }

  Widget _createLayoutForSingleProfile(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Row(
        children: [
          Expanded(
            child: CachedMemberOverviewTile(member: members.first),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _createLayoutForTwoThreeProfiles(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Row(
        children: members
            .map(
              (member) => Expanded(
                child: CachedMemberOverviewTile(member: member),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _createLayoutManyProfiles(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: _padding,
        child: Row(
          children: members
              .map(
                (member) => SizedBox(
                  width: size.width * 0.29,
                  child: CachedMemberOverviewTile(member: member),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
