import 'package:givt_app/features/family/features/bedtime/presentation/models/bedtime.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';

class BedtimeArguments {
  BedtimeArguments(this.previousBedtime, this.previousWinddownMinutes,
      {required this.profiles, required this.bedtimes, required this.index});

  final List<Bedtime> bedtimes;
  final List<Profile> profiles;
  final double? previousBedtime;
  final int? previousWinddownMinutes;
  final int index;

  bool get showBackButton => index > 0;
}
