sealed class SplashCustom {
  const SplashCustom();

  const factory SplashCustom.redirectToWelcome() = SplashRedirectToWelcome;
  const factory SplashCustom.redirectToEmailSignup(String email) =
      SplashRedirectToEmailSignup;
  const factory SplashCustom.noInternet() = NoInternet;
  const factory SplashCustom.experiencingIssues() = ExperiencingIssues;
}

class SplashRedirectToWelcome extends SplashCustom {
  const SplashRedirectToWelcome();
}

class SplashRedirectToEmailSignup extends SplashCustom {
  const SplashRedirectToEmailSignup(this.email);
  final String email;
}

class NoInternet extends SplashCustom {
  const NoInternet();
}

class ExperiencingIssues extends SplashCustom {
  const ExperiencingIssues();
}
