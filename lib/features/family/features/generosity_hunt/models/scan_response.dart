class ScanResponse {
  const ScanResponse({required this.item});

  factory ScanResponse.fromJson(Map<String, dynamic> json) {
    return ScanResponse(
      item: ScanItem.fromJson(json['item'] as Map<String, dynamic>),
    );
  }
  
  final ScanItem? item;
}

class ScanItem {
  const ScanItem({
    required this.creditsEarned,
    required this.totalCreditsEarned,
    required this.itemsRemaining,
    required this.productAlreadyScanned,
    required this.wrongProductScanned,
  });

  factory ScanItem.fromJson(Map<String, dynamic> json) {
    return ScanItem(
      creditsEarned: json['creditsEarned'] as int,
      totalCreditsEarned: json['totalCreditsEarned'] as int,
      itemsRemaining: json['itemsRemaining'] as int,
      productAlreadyScanned: json['productAlreadyScanned'] as bool,
      wrongProductScanned: json['wrongProductScanned'] as bool,
    );
  }
  final int creditsEarned;
  final int totalCreditsEarned;
  final int itemsRemaining;
  final bool productAlreadyScanned;
  final bool wrongProductScanned;
}
