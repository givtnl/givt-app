/// Thrown when the user is not logged in
final class NotLoggedInException implements Exception {
  const NotLoggedInException();

  @override
  String toString() => 'Error: User is not logged in';
}
