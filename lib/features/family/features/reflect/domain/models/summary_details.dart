import 'package:givt_app/features/family/features/profiles/models/profile.dart';

class SummaryDetails {
  SummaryDetails({
    required this.minutesPlayed,
    required this.generousDeeds,
    required this.tagsWereSelected,
    this.players = const [],
    this.audioPath = '',
    this.xpEarnedForTime,
    this.xpEarnedForDeeds,
  });

  int minutesPlayed;
  int generousDeeds;
  bool tagsWereSelected;
  List<Profile> players;
  String audioPath;
  int? xpEarnedForTime;
  int? xpEarnedForDeeds;

  bool get showPlayer => audioPath.isNotEmpty;

  bool get showRecorder => audioPath.isEmpty;
}
