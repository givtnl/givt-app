import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/history/history_cubit/history_cubit.dart';
import 'package:givt_app/features/family/features/history/history_screen.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_text_button.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class MyGivtsButton extends StatefulWidget {
  const MyGivtsButton({required this.userId, super.key});

  final String userId;

  @override
  State<MyGivtsButton> createState() => _MyGivtsButtonState();
}

class _MyGivtsButtonState extends State<MyGivtsButton> {
  @override
  Widget build(BuildContext context) {
    return FunTextButton.small(
      onTap: () {
        SystemSound.play(SystemSoundType.click);
        getIt<HistoryCubit>().fetchHistory(
          widget.userId,
          fromBeginning: true,
        );
        Navigator.of(context).push(const HistoryScreen().toRoute(context));
      },
      text: 'My Givts',
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.seeDonationHistoryPressed,
        parameters: {'userId': widget.userId},
      ),
    );
  }
}
