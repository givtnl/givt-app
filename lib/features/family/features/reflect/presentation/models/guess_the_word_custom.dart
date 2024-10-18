

sealed class GuessTheWordCustom {
  const GuessTheWordCustom();

  const factory GuessTheWordCustom.showConfetti() = ShowConfetti;
}

class ShowConfetti extends GuessTheWordCustom {
  const ShowConfetti();
}
