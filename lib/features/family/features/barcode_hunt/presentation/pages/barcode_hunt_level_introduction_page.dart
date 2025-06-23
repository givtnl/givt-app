import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/barcode_hunt/cubit/barcode_hunt_level_intro_cubit.dart';
import 'package:givt_app/features/family/features/barcode_hunt/presentation/pages/barcode_level_scan_page.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_medium_text.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class LevelIntroData {
  const LevelIntroData({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    this.description,
    this.buttonText = 'Start level',
  });

  final String imageAsset;
  final String title;
  final String subtitle;
  final String? description;
  final String? buttonText;
}

const Map<int, LevelIntroData> levelIntroData = {
  1: LevelIntroData(
    imageAsset: 'assets/family/images/level_1_explenation_image.svg',
    title: 'Scan 1 item you can eat',
    subtitle: 'Complete the level and earn Givt Credits!',
  ),
  // Add more levels here:
  // 2: LevelIntroData(
  //   imageAsset: 'assets/family/images/level_2_explenation_image.svg',
  //   title: 'Level 2 Title',
  //   subtitle: 'Level 2 Subtitle',
  //   description: 'Optional description for level 2',
  //   buttonText: 'Start level',
  // ),
};

class BarcodeHuntLevelIntroductionPage extends StatefulWidget {
  const BarcodeHuntLevelIntroductionPage({super.key});

  @override
  State<BarcodeHuntLevelIntroductionPage> createState() =>
      _BarcodeHuntLevelIntroductionPageState();
}

class _BarcodeHuntLevelIntroductionPageState
    extends State<BarcodeHuntLevelIntroductionPage> {
  final BarcodeHuntLevelIntroCubit cubit = BarcodeHuntLevelIntroCubit(getIt());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: cubit,
      onData: (context, state) {
        final data = levelIntroData[state.selectedLevel];
        if (data != null) {
          return FunScaffold(
            appBar: FunTopAppBar(
              title: 'Level ${state.selectedLevel}',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                SvgPicture.asset(
                  data.imageAsset,
                  height: 180,
                ),
                const SizedBox(height: 32),
                TitleMediumText(
                  data.title,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                BodyMediumText(
                  data.subtitle,
                  textAlign: TextAlign.center,
                ),
                if (data.description != null) ...[
                  const SizedBox(height: 12),
                  BodyMediumText(
                    data.description!,
                    textAlign: TextAlign.center,
                  ),
                ],
                const Spacer(),
                FunButton(
                  text: data.buttonText ?? 'Start level',
                  analyticsEvent:
                      AnalyticsEvent(AmplitudeEvents.funMissionCardClicked),
                  onTap: () {
                    Navigator.of(context).push(
                      const BarcodeLevelScanPage().toRoute(context),
                    );
                  },
                ),
              ],
            ),
          );
        }
        // Placeholder for other levels not yet defined
        return Scaffold(
          appBar: FunTopAppBar(
            title: 'Level Introduction',
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Center(
            child: Text('Introduction for Level #${state.selectedLevel}'),
          ),
        );
      },
    );
  }
}
