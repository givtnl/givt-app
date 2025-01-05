import 'package:givt_app/features/family/features/profiles/models/profile.dart';

sealed class GuessTheWordCustom {
  const GuessTheWordCustom();

  const factory GuessTheWordCustom.showConfetti() = ShowConfetti;
  const factory GuessTheWordCustom.redirectToSummary() = RedirectToSummary;
}

class ShowConfetti extends GuessTheWordCustom {
  const ShowConfetti();
}

class RedirectToSummary extends GuessTheWordCustom {
  const RedirectToSummary();
}