import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Primary', type: FunBottomSheet)
Widget funBottomSheetPrimary(BuildContext context) {
  return Container(
    child: OutlinedButton(
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        builder: (context) => FunBottomSheet(
          title: 'Title',
          content: Text('content'),
          closeAction: () {},
          primaryButton: FunButton(onTap: (){}, text: 'test', analyticsEvent: AnalyticsEvent( AmplitudeEvents.debugButtonClicked )),
        ),
      ),
      child: Text('test'),
    ),
  );
}
