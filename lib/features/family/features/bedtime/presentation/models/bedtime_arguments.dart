import 'package:givt_app/features/family/features/profiles/models/profile.dart';

class BedtimeArguments {
  BedtimeArguments(this.previousBedtime, this.previousWinddownMinutes,
      {required this.profiles, this.showBackButton = true});

  final List<Profile> profiles;
  final bool showBackButton;
  final DateTime? previousBedtime;
  final int? previousWinddownMinutes;
}
