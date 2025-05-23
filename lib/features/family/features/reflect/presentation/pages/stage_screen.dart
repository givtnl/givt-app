import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/background_audio/presentation/fun_background_audio_widget.dart';
import 'package:givt_app/features/family/features/gratitude-summary/bloc/record_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/stage_cubit.dart';
import 'package:givt_app/features/family/features/reflect/presentation/dialogs/microphone_permissions_dialog.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/stage_screen_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/sheets/ai_game_explanation_sheet.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class StageScreen extends StatefulWidget {
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
  State<StageScreen> createState() => _StageScreenState();
}

class _StageScreenState extends State<StageScreen> with WidgetsBindingObserver {
  final StageCubit _stageCubit = getIt<StageCubit>();
  final RecordCubit _recordCubit = getIt<RecordCubit>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _stageCubit.onResume();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stageCubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: FamilyAppTheme.tertiary10,
      child: FunScaffold(
        backgroundColor: FamilyAppTheme.tertiary10,
        canPop: false,
        withSafeArea: false,
        appBar: const FunTopAppBar(
          systemNavigationBarColor: FamilyAppTheme.tertiary10,
          title: '',
          actions: [LeaveGameButton()],
        ),
        body: BaseStateConsumer(
          cubit: _stageCubit,
          onCustom: _handleCustom,
          onData: (context, uiModel) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: FamilyAppTheme.tertiary10,
                      image: DecorationImage(
                        image: AssetImage(
                          uiModel.isAITurnedOn
                              ? 'assets/family/images/stage_with_ai.png'
                              : 'assets/family/images/stage_without_ai.png',
                        ),
                        fit: BoxFit.cover,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                    child: Stack(
                      children: [
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox.shrink(),
                        ),
                        if (widget.playAudio)
                          const FunBackgroundAudioWidget(
                            audioPath: 'family/audio/ready_its_showtime.wav',
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  color: FamilyAppTheme.tertiary10,
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (uiModel.showAIFeatures &&
                            widget.fromInitialExplanationScreen)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  FunAvatar.captainAi(),
                                  const SizedBox(width: 8),
                                  const TitleSmallText(
                                    'Captain Ai',
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              Switch.adaptive(
                                activeColor: FamilyAppTheme.primary70,
                                inactiveTrackColor: Colors.white.withValues(
                                  alpha: 0.5,
                                ),
                                value: uiModel.isAITurnedOn,
                                onChanged: (bool value) {
                                  _stageCubit.onAIEnabledChanged(
                                    isEnabled: value,
                                  );
                                  AnalyticsHelper.logEvent(
                                    eventName:
                                        AmplitudeEvents.userToggledAIFeature,
                                    eventProperties: {
                                      'on': value,
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        FunButton(
                          onTap: () => widget.onClickButton(context),
                          text: widget.buttonText,
                          analyticsEvent: AnalyticsEvent(
                            AmplitudeEvents.supersShowItsShowtimeClicked,
                            parameters: {
                              'fromInitialExplanationScreen':
                                  widget.fromInitialExplanationScreen,
                              'isAITurnedOn': uiModel.isAITurnedOn,
                              'buttonText': widget.buttonText,
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showMicrophoneSettingsPopup(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      scrollControlDisabledMaxHeightRatio: 0.8,
      builder: (context) {
        return MicrophonePermissionsDialog(
          hasDialogLayout: false,
          onClickClose: _stageCubit.onMicrophonePermissionDeclined,
        );
      },
    );
  }

  void _handleCustom(BuildContext context, StageScreenCustom custom) {
    switch (custom) {
      case CaptainAiPopup():
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) {
            return AiGameExplanationSheet(
              enableClicked: () async {
                await _stageCubit.tryToTurnOnCaptainAI();
                Navigator.of(context).pop();
              },
              maybeLaterClicked: () {
                _stageCubit.maybeLaterCaptainAi();
                Navigator.of(context).pop();
              },
            );
          },
        );
      case OpenMicrophonePermissionsDialog():
        _showMicrophoneSettingsPopup(context);
    }
  }
}
