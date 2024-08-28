sealed class Role {
  const Role();

  const factory Role.superhero(String secretWord) = SuperHero;

  const factory Role.reporter(List<String> questions) = Reporter;

  const factory Role.sidekick() = Sidekick;
}

class SuperHero extends Role {
  const SuperHero(this.secretWord);

  final String? secretWord;
}

class Reporter extends Role {
  const Reporter(this.questions);

  final List<String>? questions;
}

class Sidekick extends Role {
  const Sidekick();
}
