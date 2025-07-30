class ScanResponse {
  final ScanItem? item;

  const ScanResponse({required this.item});

  factory ScanResponse.fromJson(Map<String, dynamic> json) {
    return ScanResponse(
      item: ScanItem.fromJson(json['item'] as Map<String, dynamic>),
    );
  }
}

class ScanItem {
  final int creditsEarned;
  final int totalCreditsEarned;
  final int itemsRemaining;

  const ScanItem({
    required this.creditsEarned,
    required this.totalCreditsEarned,
    required this.itemsRemaining,
  });

  factory ScanItem.fromJson(Map<String, dynamic> json) {
    return ScanItem(
      creditsEarned: json['creditsEarned'] as int,
      totalCreditsEarned: json['totalCreditsEarned'] as int,
      itemsRemaining: json['itemsRemaining'] as int,
    );
  }
} 