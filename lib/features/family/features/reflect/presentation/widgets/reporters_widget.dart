import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/game_profile_item.dart';

class ReportersWidget extends StatelessWidget {
  const ReportersWidget(
      {required this.reporters,
      this.circleSize = 100,
      this.displayName = true,
      super.key});
  final List<GameProfile> reporters;
  final double circleSize;
  final bool displayName;
  @override
  Widget build(BuildContext context) {
    switch (reporters.length) {
      case 1:
        return GameProfileItem(
          profile: reporters.first,
          displayRole: false,
          displayName: displayName,
          size: circleSize,
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 1,
                  child: SizedBox(
                    height: circleSize - 28,
                    width: circleSize - 28,
                  ),
                ),
                Positioned(
                  right: 8,
                  child: GameProfileItem(
                    profile: reporters[1],
                    size: circleSize - 20,
                    displayRole: false,
                    displayName: displayName,
                  ),
                ),
                GameProfileItem(
                  profile: reporters.first,
                  displayRole: false,
                  displayName: displayName,
                  size: circleSize,
                ),
              ],
            ),
          ),
        );
      case >= 3:
        final reportersShort = reporters.take(3).toList();
        return SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ...reportersShort.reversed.map((reporter) {
                return Positioned(
                  right: reportersShort.indexOf(reporter) == 1 ? 28 : null,
                  left: reportersShort.indexOf(reporter) == 2 ? 28 : null,
                  child: reportersShort.indexOf(reporter) == 0
                      ? GameProfileItem(
                          profile: reporter,
                          size: circleSize,
                          displayRole: false,
                          displayName: displayName,
                        )
                      : GameProfileItem(
                          profile: reporter,
                          size: circleSize - 20,
                          displayRole: false,
                          displayName: displayName,
                        ),
                );
              }),
            ],
          ),
        );
      default:
        return GameProfileItem(
          profile: reporters.first,
          displayName: displayName,
          displayRole: false,
          size: circleSize,
        );
    }
  }
}
