import 'package:givt_app/features/give/models/for_you_goal_line.dart';

/// PostHog parameters for `for_you_giving_continue_tapped`.
///
/// Collection rows use `Collection {index}` keys (same as legacy `continue_clicked`).
/// General goals use `General goal: {name}` or `General goal {n}` when unnamed.
Map<String, dynamic> buildForYouGivingContinueAnalyticsParameters({
  required List<ForYouGoalLineKind> lines,
  required List<String> amountTexts,
}) {
  assert(
    lines.length == amountTexts.length,
    'lines and amountTexts must align',
  );

  final parameters = <String, dynamic>{};
  var generalOrdinal = 0;

  for (var i = 0; i < lines.length; i++) {
    final amount = amountTexts[i];
    switch (lines[i]) {
      case ForYouCollectionGoalLine(:final subtitleIndex):
        parameters['Collection $subtitleIndex'] = amount;
      case ForYouGeneralGoalLine(:final qr):
        generalOrdinal++;
        final name = qr.allocationName.trim();
        final key = name.isNotEmpty
            ? 'General goal: $name'
            : 'General goal $generalOrdinal';
        parameters[key] = amount;
    }
  }

  return parameters;
}
