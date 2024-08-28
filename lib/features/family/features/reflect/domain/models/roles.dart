
sealed class Role {
  const Role();

  const factory Role.superhero() = SuperHero;

  const factory Role.reporter() = Reporter;

  const factory Role.sidekick() = Sidekick;
}

class SuperHero extends Role {
  const SuperHero();
}

class Reporter extends Role {
  const Reporter();
}

class Sidekick extends Role {
  const Sidekick();
}