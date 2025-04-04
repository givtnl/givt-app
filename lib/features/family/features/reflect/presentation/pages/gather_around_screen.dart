import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/background_audio/bloc/background_audio_cubit.dart';
import 'package:givt_app/features/family/features/background_audio/presentation/fun_background_audio_widget.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/summary_screen.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GatherAroundScreen extends StatefulWidget {
  const GatherAroundScreen({super.key});

  @override
  State<GatherAroundScreen> createState() => _GatherAroundScreenState();
}

class _GatherAroundScreenState extends State<GatherAroundScreen> {
  bool _hasPlayedAudio = false;
  bool isFirstGame = true;
  final BackgroundAudioCubit _cubit = getIt<BackgroundAudioCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.isFirstGame().then((value) {
      if (!mounted) return;
      setState(() {
        isFirstGame = value;
      });
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      minimumPadding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
      backgroundColor: FamilyAppTheme.secondary20,
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/family/images/gather_around.svg',
            fit: BoxFit.cover,
            width: MediaQuery.sizeOf(context).width,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              FunAvatar.family(
                isLarge: true,
              ),
              const SizedBox(height: 16),
              FunBackgroundAudioWidget(
                isVisible: true,
                audioPath: 'family/audio/gather_around.wav',
                onPauseOrStop: () {
                  setState(() {
                    _hasPlayedAudio = true;
                  });
                },
                iconColor: Colors.white,
              ),
              const SizedBox(height: 16),
              const TitleMediumText(
                'Family, gather around',
                textAlign: TextAlign.center,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FunButton(
                  isDisabled: !_hasPlayedAudio && isFirstGame,
                  onTap: () {
                    Navigator.of(context)
                        .push(const SummaryScreen().toRoute(context));
                  },
                  text: 'Show our summary',
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.reflectAndShareShowSummaryClicked,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
