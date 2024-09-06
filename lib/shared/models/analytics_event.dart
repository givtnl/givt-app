import 'package:givt_app/core/enums/amplitude_events.dart';

class AnalyticsEvent {
  AnalyticsEvent(this.name, {this.parameters = const <String, dynamic>{}});

  final AmplitudeEvents name;
  final Map<String, dynamic> parameters;
}
