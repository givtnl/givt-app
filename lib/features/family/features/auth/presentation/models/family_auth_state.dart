import 'package:givt_app/shared/models/models.dart';

sealed class FamilyAuthState {
  const FamilyAuthState();

  const factory FamilyAuthState.authenticated(UserExt user) = Authenticated;

  const factory FamilyAuthState.unauthenticated() = Unauthenticated;
}

class Authenticated extends FamilyAuthState {
  const Authenticated(this.user);

  final UserExt user;
}

class Unauthenticated extends FamilyAuthState {
  const Unauthenticated();
}
