sealed class LeaveGameCustom {
  const LeaveGameCustom();

  const factory LeaveGameCustom.grateful() = LeaveGameCustomGrateful;

  const factory LeaveGameCustom.home() = LeaveGameCustomHome;

  const factory LeaveGameCustom.summary() = LeaveGameCustomSummary;
}

class LeaveGameCustomGrateful extends LeaveGameCustom {
  const LeaveGameCustomGrateful();
}

class LeaveGameCustomHome extends LeaveGameCustom {
  const LeaveGameCustomHome();
}

class LeaveGameCustomSummary extends LeaveGameCustom {
  const LeaveGameCustomSummary();
}
