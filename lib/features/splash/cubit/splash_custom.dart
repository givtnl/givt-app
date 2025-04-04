sealed class SplashCustom {
  const SplashCustom();

  const factory SplashCustom.redirectToWelcome() = SplashRedirectToWelcome;
  const factory SplashCustom.redirectToUSRegistration(String email) =
      SplashRedirectToUSRegistration;
  const factory SplashCustom.redirectToEmailSignup(String email) =
      SplashRedirectToEmailSignup;
  const factory SplashCustom.redirectToUSHome() = SplashRedirectToUSHome;
  const factory SplashCustom.redirectToEUHome() = SplashRedirectToEUHome;
  const factory SplashCustom.redirectToAddMembers() =
      SplashRedirectToAddMembers;
  const factory SplashCustom.noInternet() = NoInternet;
  const factory SplashCustom.experiencingIssues() = ExperiencingIssues;
}

class SplashRedirectToWelcome extends SplashCustom {
  const SplashRedirectToWelcome();
}

class SplashRedirectToUSRegistration extends SplashCustom {
  const SplashRedirectToUSRegistration(this.email);
  final String email;
}

class SplashRedirectToEmailSignup extends SplashCustom {
  const SplashRedirectToEmailSignup(this.email);
  final String email;
}


class SplashRedirectToUSHome extends SplashCustom {
  const SplashRedirectToUSHome();
}

class SplashRedirectToEUHome extends SplashCustom {
  const SplashRedirectToEUHome();
}

class SplashRedirectToAddMembers extends SplashCustom {
  const SplashRedirectToAddMembers();
}

class NoInternet extends SplashCustom {
  const NoInternet();
}

class ExperiencingIssues extends SplashCustom {
  const ExperiencingIssues();
}
