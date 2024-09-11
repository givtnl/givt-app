import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Primary', type: FunButton, designLink: 'https://www.figma.com/design/TpvZkfxdBBBlGmTD7QyxJ3/FUN-Design-System?node-id=54585-30129&t=8tRS5nTy6XaUkJEM-1')
Widget funButtonPrimary(BuildContext context) {
  return FunButton(
    onTap: () {},
    text: context.knobs.string(
      label: 'Text',
      initialValue: 'Default',
    ),
    isDisabled: context.knobs.boolean(
      label: 'Disabled',
      initialValue: false,
    ),
    analyticsEvent: AnalyticsEvent(
      AmplitudeEvents.debugButtonClicked,
    ),
  );
}

@widgetbook.UseCase(name: 'Secondary', type: FunButton, designLink: 'https://www.figma.com/design/TpvZkfxdBBBlGmTD7QyxJ3/FUN-Design-System?node-id=54585-30129&t=8tRS5nTy6XaUkJEM-1')
Widget funButtonSecondary(BuildContext context) {
  return FunButton.secondary(
    onTap: () {},
    text: context.knobs.string(
      label: 'Text',
      initialValue: 'Default',
    ),
    isDisabled: context.knobs.boolean(
      label: 'Disabled',
      initialValue: false,
    ),
    analyticsEvent: AnalyticsEvent(
      AmplitudeEvents.debugButtonClicked,
    ),
  );
}

@widgetbook.UseCase(name: 'Tertiary', type: FunButton, designLink: 'https://www.figma.com/design/TpvZkfxdBBBlGmTD7QyxJ3/FUN-Design-System?node-id=54585-30129&t=8tRS5nTy6XaUkJEM-1')
Widget funButtonTertiary(BuildContext context) {
  return FunButton.tertiary(
    onTap: () {},
    text: context.knobs.string(
      label: 'Text',
      initialValue: 'Default',
    ),
    isDisabled: context.knobs.boolean(
      label: 'Disabled',
      initialValue: false,
    ),
    analyticsEvent: AnalyticsEvent(
      AmplitudeEvents.debugButtonClicked,
    ),
  );
}