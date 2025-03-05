import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/bloc/reflect_intro_cubit.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/reflect_intro_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/family_selection_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/stage_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/sheets/ai_game_explanation_sheet.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class ReflectIntroScreen extends StatefulWidget {
  const ReflectIntroScreen({super.key});

  @override
  State<ReflectIntroScreen> createState() => _ReflectIntroScreenState();
}

class _ReflectIntroScreenState extends State<ReflectIntroScreen> {
  final ReflectIntroCubit _cubit = getIt<ReflectIntroCubit>();

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: const FunTopAppBar(
        title: 'Gratitude Game',
        leading: GivtBackButtonFlat(),
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onCustom: _handleCustom,
        onData: (context, _) {
          return _layout();
        },
        onInitial: (context) {
          return _layout();
        },
      ),
    );
  }

  Column _layout() {
    return Column(
      children: [
        const Spacer(),
        SvgPicture.asset('assets/family/images/family_on_rug.svg'),
        const SizedBox(height: 32),
        const BodyMediumText(
          "Look back on today.\nShare what you're grateful for. Find ways to spread kindness together.",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        const Spacer(),
        FunButton(
          onTap: _cubit.onStartClicked,
          text: "Let's go",
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.reflectAndShareLetsGoClicked,
          ),
        ),
      ],
    );
  }

  void _handleCustom(BuildContext context, ReflectIntroCustom custom) {
    switch (custom) {
      case GoToStageScreen():
        _goToStageScreen(context);
    }
  }

  void _goToStageScreen(BuildContext context) {
    Navigator.of(context).push(
      StageScreen(
        fromInitialExplanationScreen: true,
        buttonText: 'Start',
        onClickButton: (context) {
          Navigator.of(context)
              .push(const FamilySelectionScreen().toRoute(context));
        },
      ).toRoute(context),
    );
  }
}
