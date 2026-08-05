part of 'offline_queue_cubit.dart';

class OfflineQueueState extends Equatable {
  const OfflineQueueState({
    required this.isOffline,
    required this.pendingCount,
    required this.totalAmount,
    required this.hasResolvedConnectivity,
  });

  factory OfflineQueueState.initial({required bool isOffline}) {
    return OfflineQueueState(
      isOffline: isOffline,
      pendingCount: 0,
      totalAmount: 0,
      hasResolvedConnectivity: false,
    );
  }

  final bool isOffline;
  final int pendingCount;
  final double totalAmount;
  final bool hasResolvedConnectivity;

  bool get shouldShowBanner =>
      pendingCount > 0 || (hasResolvedConnectivity && isOffline);

  @override
  List<Object> get props => [
    isOffline,
    pendingCount,
    totalAmount,
    hasResolvedConnectivity,
  ];
}
