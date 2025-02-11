import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/history/history_cubit/history_cubit.dart';
import 'package:givt_app/features/family/features/history/history_screen.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/utils/utils.dart';

class MyGivtsTextButton extends StatefulWidget {
  const MyGivtsTextButton({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  _MyGivtsTextButtonState createState() => _MyGivtsTextButtonState();
}

class _MyGivtsTextButtonState extends State<MyGivtsTextButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        alignment: Alignment.topCenter,
      ),
      onPressed: () {
        SystemSound.play(SystemSoundType.click);
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.seeDonationHistoryPressed,
        );
        getIt<HistoryCubit>().fetchHistory(
          widget.userId,
          fromBeginning: true,
        );
        Navigator.of(context).push(const HistoryScreen().toRoute(context));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LabelMediumText('My givts'),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(
              FontAwesomeIcons.arrowRight,
              size: 20,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
