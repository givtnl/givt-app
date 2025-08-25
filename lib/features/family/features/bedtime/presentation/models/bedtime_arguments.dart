import 'package:givt_app/features/family/features/bedtime/presentation/models/bedtime.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';

class BedtimeArguments {
  BedtimeArguments({
    required this.profiles, this.previousBedtime = BedtimeConfig.defaultBedtimeHour,
    this.previousWinddownMinutes = BedtimeConfig.defaultWindDownMinutes,
    this.bedtimes = const [],
    this.index = 0,
    this.fromTutorial = false,
  });

  final List<Bedtime> bedtimes;
  final List<Profile> profiles;
  final double? previousBedtime;
  final int? previousWinddownMinutes;
  final int index;
  final bool fromTutorial;

  bool get showBackButton => index > 0;
}
