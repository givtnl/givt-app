import 'package:givt_app/features/give/models/for_you_flow_context.dart';

/// One-off navigation / side effects for the beacon discovery cubit.
sealed class ForYouBeaconDiscoveryCustom {
  const ForYouBeaconDiscoveryCustom();
}

/// Navigate to organisation confirm with the resolved organisation.
final class ForYouBeaconNavigateToConfirm extends ForYouBeaconDiscoveryCustom {
  const ForYouBeaconNavigateToConfirm(this.flowContext);

  final ForYouFlowContext flowContext;
}

/// Bluetooth not supported — fall back to For You list.
final class ForYouBeaconNavigateToList extends ForYouBeaconDiscoveryCustom {
  const ForYouBeaconNavigateToList(this.flowContext);

  final ForYouFlowContext flowContext;
}
