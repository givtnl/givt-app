enum CollecGroupType {
  church(0),
  campaign(1),
  artists(2),
  charities(3),
  unknown(4),
  demo(5),
  debug(6);

  const CollecGroupType(this.value);
  final int value;
}
