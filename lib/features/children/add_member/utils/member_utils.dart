DateTime getDateOfBirthFromAge(int age) {
  final birthYear = DateTime.now().year - age;
  return DateTime(birthYear);
}
