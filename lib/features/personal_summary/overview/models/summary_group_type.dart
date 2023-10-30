enum SummaryGroupType {
  perMonth('0'),
  perYear('1'),
  perDestination('2');

  const SummaryGroupType(this.type);

  final String type;
}
