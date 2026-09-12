enum DonationHistorySource {
  givtProcessed,
  external;

  static DonationHistorySource fromJson(String? value) {
    switch (value) {
      case 'external':
        return DonationHistorySource.external;
      case 'givtProcessed':
      default:
        return DonationHistorySource.givtProcessed;
    }
  }
}
