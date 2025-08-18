import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/box_origin/bloc/box_origin_cubit.dart';
import 'package:givt_app/features/family/features/box_origin/presentation/box_origin_selection_page.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_text_button.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_top_app_bar.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class BoxOriginQuestionScreen extends StatefulWidget {
  const BoxOriginQuestionScreen({super.key});

  @override
  State<BoxOriginQuestionScreen> createState() =>
      _BoxOriginQuestionScreenState();
}

class _BoxOriginQuestionScreenState extends State<BoxOriginQuestionScreen> {
  final _cubit = getIt<BoxOriginCubit>();

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      appBar: FunTopAppBar.primary99(
        title: context.l10n.originQuestionTitle, // Last step
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: TitleMediumText(
              'What church do you go to?', // Where did you get your box?
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          const Align(
            child: FunIcon(
              iconData: FontAwesomeIcons.earListen,
            ),
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FunButton(
                text: context.l10n.originSelectLocation, // Select location
                onTap: () async {
                  await Navigator.push(
                    context,
                    BoxOriginSelectionPage(setBoxOrigin: _cubit.setBoxOrigin)
                        .toRoute(context),
                  );
                },
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.continueChooseChurchClicked,
                ),
              ),
              const SizedBox(height: 8),
              FunTextButton(
                text: context.l10n.buttonSkip,
                onTap: () {
                  _cubit.onSkipClicked();
                  context.goNamed(FamilyPages.profileSelection.name);
                },
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.dontHaveABoxClicked,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
