class UnlockBadgeFeature {
  const UnlockBadgeFeature({
    required this.id,
    required this.isSeen,
    this.count = 0,
  });

  final String id;
  final bool isSeen;
  final int count;

  UnlockBadgeFeature copyWith({
    String? id,
    bool? isSeen,
    int? count,
  }) {
    return UnlockBadgeFeature(
      id: id ?? this.id,
      isSeen: isSeen ?? this.isSeen,
      count: count ?? this.count,
    );
  }
}
