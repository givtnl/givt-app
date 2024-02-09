// ignore_for_file: constant_identifier_names

enum ProfileType {
  Parent,
  Child;

  static ProfileType getByTypeName(String typeName) {
    try {
      return ProfileType.values.byName(typeName);
    } catch (_) {
      return ProfileType.Child;
    }
  }
}
