/// Scope for recurring external-donation updates (BFF `scope` field).
enum ExternalDonationUpdateScope {
  all(0),
  onwards(1);

  const ExternalDonationUpdateScope(this.apiValue);

  final int apiValue;
}
