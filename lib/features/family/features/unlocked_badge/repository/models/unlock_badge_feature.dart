class UnlockBadgeFeature {
  const UnlockBadgeFeature({
    required this.id,
    required this.isSeen,
    this.count = 0,
  });

  final String id;
  final bool isSeen;
  final int count;
}
