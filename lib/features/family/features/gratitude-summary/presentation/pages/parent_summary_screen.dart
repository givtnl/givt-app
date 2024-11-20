import 'package:flutter/cupertino.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/gratitude-summary/bloc/yesno-cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class YesNoScreen extends StatefulWidget {
  const YesNoScreen({required this.name, required this.childGuid, super.key});

  final String name;
  final String childGuid;

  @override
  State<YesNoScreen> createState() => _YesNoScreenState();
}

class _YesNoScreenState extends State<YesNoScreen> {
  final YesNoCubit _cubit = getIt<YesNoCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.init(widget.childGuid);
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: FunTopAppBar(
        title: 'Are you putting ${widget.name} to bed?',
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onCustom: (context, decisionWasYes) {
          if (decisionWasYes) {
            context.goNamed(FamilyPages.reflectIntro.name);
          } else {
            context.pop();
          }
        },
        onInitial: (context) {
          return Column(
            children: [
              FunButton(
                text: 'Yes',
                onTap: _cubit.onClickedYes,
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.whoDoesBedtimePushYesClicked,
                ),
              ),
              FunButton.secondary(
                text: 'No',
                onTap: _cubit.onClickedNo,
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.whoDoesBedtimePushNoClicked,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
