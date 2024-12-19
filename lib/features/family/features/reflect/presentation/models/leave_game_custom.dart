import 'package:givt_app/features/family/features/profiles/models/profile.dart';

sealed class LeaveGameCustom {
  const LeaveGameCustom();

  const factory LeaveGameCustom.grateful() = LeaveGameCustomGrateful;

  const factory LeaveGameCustom.home() = LeaveGameCustomHome;

  const factory LeaveGameCustom.introBedtime(List<Profile> profiles) =
      LeaveGameCustomIntroBedtime;

  const factory LeaveGameCustom.summary() = LeaveGameCustomSummary;
}

class LeaveGameCustomGrateful extends LeaveGameCustom {
  const LeaveGameCustomGrateful();
}

class LeaveGameCustomHome extends LeaveGameCustom {
  const LeaveGameCustomHome();
}

class LeaveGameCustomIntroBedtime extends LeaveGameCustom {
  const LeaveGameCustomIntroBedtime(this.profiles);

  final List<Profile> profiles;
}

class LeaveGameCustomSummary extends LeaveGameCustom {
  const LeaveGameCustomSummary();
}
