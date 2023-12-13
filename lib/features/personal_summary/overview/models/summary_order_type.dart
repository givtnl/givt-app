enum SummaryOrderType {
  key('0'),
  count('1'),
  sum('2'),
  donationDate('3');

  const SummaryOrderType(this.type);

  final String type;

}
