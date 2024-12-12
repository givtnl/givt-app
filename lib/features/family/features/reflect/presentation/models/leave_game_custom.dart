import 'package:givt_app/features/family/features/profiles/models/profile.dart';

class LeaveGameCustom {
  const LeaveGameCustom({
    required this.isFirstRound,
    required this.hasAtLeastStartedInterview,
    required this.kidsWithoutBedtimeSetup,
  });

  final bool isFirstRound;
  final bool hasAtLeastStartedInterview;
  final List<Profile> kidsWithoutBedtimeSetup;
}
