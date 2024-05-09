enum Area {
  health(value: 'HEALTH'),
  education(value: 'EDUCATION'),
  environment(value: 'ENVIRONMENT'),
  disaster(value: 'DISASTER'),
  basic(value: 'BASIC'),
  none(value: 'NONE'),
  ;

  const Area({
    required this.value,
  });

  final String value;

  static Area fromString(String value) => Area.values.firstWhere(
        (element) => element.value == value,
        orElse: () => Area.none,
      );
}
