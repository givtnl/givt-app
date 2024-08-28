import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';

class StartInterview extends StatelessWidget {
  const StartInterview({required this.reporters, super.key});
  final List<GameProfile> reporters;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FamilyAppTheme.secondary90,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TitleMediumText(
              'Pass the phone to the\n reporter ${reporters[0].firstName}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
