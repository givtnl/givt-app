enum DonationHistorySource {
  givtProcessed,
  external;

  /// BFF `JsonStringEnumConverter` emits PascalCase (`External`) unless a
  /// camelCase naming policy is set. Accept both.
  static DonationHistorySource fromJson(Object? value) {
    switch (value?.toString().toLowerCase()) {
      case 'external':
      case '1':
        return DonationHistorySource.external;
      default:
        return DonationHistorySource.givtProcessed;
    }
  }
}
