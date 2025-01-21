import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/box_origin/bloc/box_origin_cubit.dart';
import 'package:givt_app/features/family/features/box_origin/presentation/box_origin_selection_page.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/fun_modal.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
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
    return FunModal(
      title: 'Can you tell us where you heard about Givt?',
      icon: const FunIcon(
        iconData: FontAwesomeIcons.earListen,
      ),
      buttons: [
        FunButton(
          text: 'Tell us',
          onTap: () async {
            context.pop(); // close modal
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
        FunButton.secondary(
          text: 'Dismiss',
          onTap: () => context.pop(),
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.dontHaveABoxClicked,
          ),
        ),
      ],
    );
  }
}
