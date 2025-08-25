import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/background_audio/presentation/animated_speaker.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/utils/utils.dart';

class VolumeBottomsheet extends StatelessWidget {
  const VolumeBottomsheet({super.key, this.onReady});
  final VoidCallback? onReady;
  @override
  Widget build(BuildContext context) {
    return FunBottomSheet(
      title: 'Turn up your volume for a better experience',
      content: const SizedBox.shrink(),
      icon: Container(
        height: 112,
        width: 112,
        decoration: const BoxDecoration(
          color: FamilyAppTheme.primary95,
          shape: BoxShape.circle,
        ),
        child: const AnimatedSpeaker(
          height: 48,
        ),
      ),
      primaryButton: FunButton(
        text: 'Ready',
        onTap: () {
          Navigator.of(context).pop();
          onReady?.call();
        },
        analyticsEvent: AmplitudeEvents.volumeBottomSheetReadyClicked.toEvent(),
      ),
    );
  }
}
