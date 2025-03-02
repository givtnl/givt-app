sealed class SplashCustom {
  const SplashCustom();

  const factory SplashCustom.redirectToWelcome() = SplashRedirectToWelcome;
  const factory SplashCustom.redirectToSignup(String email) =
      SplashRedirectToSignup;
  const factory SplashCustom.redirectToHome() = SplashRedirectToHome;
  const factory SplashCustom.redirectToAddMembers() =
      SplashRedirectToAddMembers;
  const factory SplashCustom.noInternet() = NoInternet;
  const factory SplashCustom.experiencingIssues() = ExperiencingIssues;
}

class SplashRedirectToWelcome extends SplashCustom {
  const SplashRedirectToWelcome();
}

class SplashRedirectToSignup extends SplashCustom {
  const SplashRedirectToSignup(this.email);
  final String email;
}

class SplashRedirectToHome extends SplashCustom {
  const SplashRedirectToHome();
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
