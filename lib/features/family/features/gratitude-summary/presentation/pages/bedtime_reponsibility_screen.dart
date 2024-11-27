import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/gratitude-summary/bloc/bedtime_responsibility_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/avatar_widget.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class AssignBedtimeResponsibilityScreen extends StatefulWidget {
  const AssignBedtimeResponsibilityScreen({
    required this.name,
    required this.childGuid,
    required this.imageUrl,
    super.key,
  });

  final String name;
  final String childGuid;
  final String imageUrl;

  @override
  State<AssignBedtimeResponsibilityScreen> createState() =>
      _AssignBedtimeResponsibilityScreenState();
}

class _AssignBedtimeResponsibilityScreenState
    extends State<AssignBedtimeResponsibilityScreen> {
  final AssignBedtimeResponsibilityCubit _cubit =
      getIt<AssignBedtimeResponsibilityCubit>();
  late String text;
  bool _showButtons = true;
  @override
  void initState() {
    super.initState();
    _cubit.init(widget.childGuid);
    text = 'Are you putting ${widget.name} to bed?';
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      backgroundColor: FamilyAppTheme.secondary10,
      appBar: const FunTopAppBar(
        title: 'Gratitude Game reminder',
        titleColor: Colors.white,
        color: FamilyAppTheme.secondary10,
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onCustom: (context, decisionWasYes) {
          if (decisionWasYes) {
            context.goNamed(FamilyPages.reflectIntro.name);
          } else {
            setState(() {
              text =
                  'No worries, we’ll remind the other parent to play before bed!';
              _showButtons = false;
            });
            Future.delayed(const Duration(milliseconds: 1800), () {
              context.pop();
            });
          }
        },
        onInitial: (context) {
          return body(text);
        },
      ),
    );
  }

  Widget body(String text) => Column(
        children: [
          const Spacer(),
          AvatarWidget(
              uiModel: AvatarUIModel(
                avatarUrl: widget.imageUrl,
                text: widget.name,
              ),
              circleSize: 100,
              textColor: Colors.transparent,
              onTap: () {}),
          TitleMediumText(
            text,
            textAlign: TextAlign.center,
            color: Colors.white,
          ),
          const Spacer(),
          if (_showButtons)
            FunButton(
              text: 'Yes',
              onTap: _cubit.onClickedYes,
              analyticsEvent: AnalyticsEvent(
                AmplitudeEvents.whoDoesBedtimePushYesClicked,
              ),
            ),
          const SizedBox(height: 8),
          if (_showButtons)
            FunButton.secondary(
              text: 'No',
              onTap: _cubit.onClickedNo,
              analyticsEvent: AnalyticsEvent(
                AmplitudeEvents.whoDoesBedtimePushNoClicked,
              ),
            ),
        ],
      );
}
