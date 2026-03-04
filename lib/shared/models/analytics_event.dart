import 'package:givt_app/core/enums/analytics_event_name.dart';

class AnalyticsEvent {
  AnalyticsEvent(this.name, {this.parameters = const <String, dynamic>{}});

  final AnalyticsEventName name;
  final Map<String, dynamic> parameters;
}
