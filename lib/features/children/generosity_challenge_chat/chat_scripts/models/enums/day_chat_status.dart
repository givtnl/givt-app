enum DayChatStatus {
  unavailable,
  available,
  active,
  completed;

  static DayChatStatus fromString(String value) {
    try {
      return DayChatStatus.values.byName(value);
    } catch (_) {
      return DayChatStatus.unavailable;
    }
  }
}
