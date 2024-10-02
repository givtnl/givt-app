import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';

sealed class NavigationBarHomeCustom {
  const NavigationBarHomeCustom();

  const factory NavigationBarHomeCustom.nothingYet() = NothinYet;
}

//TODO
class NothinYet extends NavigationBarHomeCustom {
  const NothinYet();
}
