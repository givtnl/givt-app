import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/game_profile_item.dart';

class ReportersWidget extends StatelessWidget {
  const ReportersWidget({required this.reporters, super.key});
  final List<GameProfile> reporters;
  @override
  Widget build(BuildContext context) {
    switch (reporters.length) {
      case 1:
        return GameProfileItem(
          profile: reporters.first,
          displayName: false,
          displayRole: false,
          size: 140,
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned(
                  left: 1,
                  child: SizedBox(
                    height: 100,
                    width: 100,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: GameProfileItem(
                    profile: reporters[1],
                    displayName: false,
                    size: 120,
                    displayRole: false,
                  ),
                ),
                GameProfileItem(
                  profile: reporters.first,
                  displayName: false,
                  displayRole: false,
                  size: 140,
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
                  right: reportersShort.indexOf(reporter) == 1 ? 36 : null,
                  left: reportersShort.indexOf(reporter) == 2 ? 36 : null,
                  child: reportersShort.indexOf(reporter) == 0
                      ? GameProfileItem(
                          profile: reporter,
                          displayName: false,
                          size: 140,
                          displayRole: false,
                        )
                      : GameProfileItem(
                          profile: reporter,
                          displayName: false,
                          size: 120,
                          displayRole: false,
                        ),
                );
              }),
            ],
          ),
        );
      default:
        return GameProfileItem(
          profile: reporters.first,
          displayName: false,
          size: 140,
        );
    }
  }
}
