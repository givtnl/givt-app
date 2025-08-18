import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/generosity_hunt/cubit/generosity_hunt_level_intro_cubit.dart';
import 'package:givt_app/features/family/features/generosity_hunt/presentation/pages/generosity_level_scan_page.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_small_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_medium_text.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GenerosityHuntLevelIntroductionPage extends StatefulWidget {
  const GenerosityHuntLevelIntroductionPage({super.key});

  @override
  State<GenerosityHuntLevelIntroductionPage> createState() =>
      _GenerosityHuntLevelIntroductionPageState();
}

class _GenerosityHuntLevelIntroductionPageState
    extends State<GenerosityHuntLevelIntroductionPage> {
  final GenerosityHuntLevelIntroCubit cubit =
      GenerosityHuntLevelIntroCubit(getIt());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: cubit,
      onLoading: (context) => const FunScaffold(
        body: Center(
          child: CustomCircularProgressIndicator(),
        ),
      ),
      onData: (context, state) {
        final level = state.level;
        if (level != null) {
          return FunScaffold(
            appBar: FunTopAppBar(
              title: 'Level ${level.level}',
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
                  level.imageAsset,
                  height: 180,
                ),
                const SizedBox(height: 32),
                TitleMediumText(
                  level.subtitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                BodySmallText(
                  level.description,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                FunButton(
                  text: 'Start level',
                  analyticsEvent:
                      AnalyticsEvent(AmplitudeEvents.generosityHuntLevelStart),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
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
            child: Text('Introduction for Level {state.selectedLevel}'),
          ),
        );
      },
    );
  }
}
