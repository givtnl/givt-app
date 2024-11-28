import 'package:givt_app/features/family/features/profiles/models/profile.dart';

class SummaryDetails {
  SummaryDetails({
    required this.minutesPlayed,
    required this.generousDeeds,
    this.missingAdults = const [],
    this.audioPath = '',
  });

  int minutesPlayed;
  int generousDeeds;
  List<Profile> missingAdults;
  String audioPath;

  String get adultName =>
      missingAdults.length == 1 ? missingAdults.first.firstName : 'the family';
  bool get allAdultsPlayed => missingAdults.isEmpty;
}
