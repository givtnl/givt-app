import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/game_profile_item.dart';

class ReportersWidget extends StatelessWidget {
  const ReportersWidget({
    required this.reporters,
    this.circleSize = 100,
    this.displayName = true,
    super.key,
  });

  final List<GameProfile> reporters;
  final double circleSize;
  final bool displayName;

  @override
  Widget build(BuildContext context) {
    if (reporters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: reporters.length == 2
          ? const EdgeInsets.symmetric(horizontal: 20)
          : EdgeInsets.zero,
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: _buildProfiles().reversed.toList(),
        ),
      ),
    );
  }

  List<Widget> _buildProfiles() {
    final profilesToShow = reporters.take(3).toList();
    return List.generate(profilesToShow.length, (index) {
      var size = circleSize;
      double? left;
      double? right;

      // Adjust position and size based on the number of reporters
      if (reporters.length == 2) {
        size -= (index == 1 ? 20 : 0); // Smaller for second profile
        right = (index == 1 ? 8 : null);
      } else if (reporters.length >= 3) {
        size -= (index > 0 ? 20 : 0);
        left = (index == 2 ? 28 : null);
        right = (index == 1 ? 28 : null);
      }

      return Positioned(
        left: left,
        right: right,
        child: GameProfileItem(
          profile: profilesToShow[index],
          size: size,
          displayRole: false,
          displayName: displayName,
        ),
      );
    });
  }
}
