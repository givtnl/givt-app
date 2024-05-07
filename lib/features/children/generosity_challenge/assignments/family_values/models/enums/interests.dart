enum Interest {
  afterDisaster(
    value: 'AFTERADISTER',
    displayText: 'After a disaster',
  ),
  careForChildren(
    value: 'CAREFORCHILDREN',
    displayText: 'Care for children',
  ),
  learnToRead(
    value: 'LEARNTOREAD',
    displayText: 'Learn to read',
  ),
  goToSchool(
    value: 'GOTOSCHOOL',
    displayText: 'Go to school',
  ),
  protectAnimals(
    value: 'PROTECTANIMALS',
    displayText: 'Protect animals',
  ),
  stayHealthy(
    value: 'STAYHEALTHY',
    displayText: 'Stay healthy',
  ),
  withDisabilities(
    value: 'WITHDISABILITIES',
    displayText: 'With disabilities',
  ),
  findAHome(
    value: 'FINDAHOME',
    displayText: 'Find a home',
  ),
  getFood(
    value: 'GETFOOD',
    displayText: 'Get food',
  ),
  thatAreHomeless(
    value: 'THATAREHOMELESS',
    displayText: 'That are homeless',
  ),
  protectForests(
    value: 'PROTECTFORESTS',
    displayText: 'Protect forests',
  ),
  none(
    value: 'NONE',
    displayText: 'None',
  );

  const Interest({
    required this.value,
    required this.displayText,
  });

  final String value;
  final String displayText;

  static Interest fromString(String value) => Interest.values.firstWhere(
        (element) => element.value == value,
        orElse: () => Interest.none,
      );
}
