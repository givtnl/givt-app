import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/background_audio/presentation/fun_background_audio_widget.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class StageScreen extends StatelessWidget {
  const StageScreen({
    required this.buttonText,
    required this.onClickButton,
    this.fromInitialExplanationScreen = false,
    this.playAudio = false,
    super.key,
  });

  final String buttonText;
  final bool playAudio;
  final bool fromInitialExplanationScreen;
  final void Function(BuildContext context) onClickButton;

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      withSafeArea: false,
      appBar: const FunTopAppBar(
        title: '',
        actions: [LeaveGameButton()],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: FamilyAppTheme.primary99,
              image: DecorationImage(
                image: AssetImage('assets/family/images/stage_background.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          if (playAudio)
            const FunBackgroundAudioWidget(
              audioPath: 'family/audio/ready_its_showtime.wav',
            ),
        ],
      ),
      floatingActionButton: FunButton(
        onTap: () => onClickButton(context),
        text: buttonText,
        analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.supersShowItsShowtimeClicked,
            parameters: {
              'fromInitialExplanationScreen': fromInitialExplanationScreen,
            }),
      ),
    );
  }
}
