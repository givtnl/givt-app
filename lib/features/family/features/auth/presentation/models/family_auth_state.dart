import 'package:givt_app/shared/models/models.dart';

sealed class FamilyAuthState {
  const FamilyAuthState();

  const factory FamilyAuthState.authenticated(UserExt user) = Authenticated;

  const factory FamilyAuthState.unauthenticated() = Unauthenticated;
}

class Authenticated extends FamilyAuthState {
  const Authenticated(this.user);

  /// The authenticated user's information.
  final UserExt user;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Authenticated &&
      runtimeType == other.runtimeType &&
      user == other.user;

  @override
  int get hashCode => user.hashCode;
}

class Unauthenticated extends FamilyAuthState {
  const Unauthenticated();
}
