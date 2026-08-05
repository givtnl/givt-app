part of 'offline_queue_cubit.dart';

class OfflineQueueState extends Equatable {
  const OfflineQueueState({
    required this.isOffline,
    required this.pendingCount,
    required this.totalAmount,
  });

  factory OfflineQueueState.initial({required bool isOffline}) {
    return OfflineQueueState(
      isOffline: isOffline,
      pendingCount: 0,
      totalAmount: 0,
    );
  }

  final bool isOffline;
  final int pendingCount;
  final double totalAmount;

  bool get shouldShowBanner => isOffline || pendingCount > 0;

  @override
  List<Object> get props => [
    isOffline,
    pendingCount,
    totalAmount,
  ];
}
