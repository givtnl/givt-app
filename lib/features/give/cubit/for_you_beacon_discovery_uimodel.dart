import 'package:equatable/equatable.dart';

/// UI phase for the For You beacon discovery screen.
enum ForYouBeaconDiscoveryPhase {
  searching,
  bluetoothOff,
  bluetoothPermissionSettings,
}

class ForYouBeaconDiscoveryUIModel extends Equatable {
  const ForYouBeaconDiscoveryUIModel({
    required this.phase,
  });

  final ForYouBeaconDiscoveryPhase phase;

  @override
  List<Object?> get props => [phase];
}
