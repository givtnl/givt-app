sealed class SplashCustom {
  const SplashCustom();

  const factory SplashCustom.redirectToWelcome() = SplashRedirectToWelcome;
  const factory SplashCustom.redirectToSignup(String email) =
      SplashRedirectToSignup;
  const factory SplashCustom.redirectToHome() = SplashRedirectToHome;
  const factory SplashCustom.redirectToAddMembers() =
      SplashRedirectToAddMembers;
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
