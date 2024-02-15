import 'package:flutter/material.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/features/children/overview/widgets/profile_overview_tile.dart';

class ProfilesOverviewWidget extends StatelessWidget {
  const ProfilesOverviewWidget({
    required this.profiles,
    super.key,
  });

  final List<Profile> profiles;

  static const EdgeInsets _padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    if (profiles.length == 1) {
      return _createLayoutForSingleProfile(context);
    } else if (profiles.length > 1 && profiles.length < 4) {
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
            child: ProfileOverviewTile(profile: profiles.first),
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
        children: profiles
            .map(
              (profile) => Expanded(
                child: ProfileOverviewTile(profile: profile),
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
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: _padding,
        child: Row(
          children: profiles
              .map(
                (profile) => SizedBox(
                  width: size.width * 0.29,
                  child: ProfileOverviewTile(profile: profile),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
