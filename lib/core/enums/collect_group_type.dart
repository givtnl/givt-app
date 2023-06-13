enum CollecGroupType {
  church(0),
  campaign(1),
  artists(2),
  charities(3),
  unknown(4),
  demo(5),
  debug(6),
  none(-1);

  const CollecGroupType(this.value);
  final int value;  

  static CollecGroupType fromInt(int value) {
    switch (value) {
      case 0:
        return CollecGroupType.church;
      case 1:
        return CollecGroupType.campaign;
      case 2:
        return CollecGroupType.artists;
      case 3:
        return CollecGroupType.charities;
      case 4:
        return CollecGroupType.unknown;
      case 5:
        return CollecGroupType.demo;
      case 6:
        return CollecGroupType.debug;
      default:
        return CollecGroupType.none;
    }
  }

  
}
