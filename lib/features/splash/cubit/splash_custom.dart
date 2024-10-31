sealed class SplashCustom {
  const SplashCustom();

  const factory SplashCustom.redirectToWelcome() = SplashRedirectToWelcome;
  const factory SplashCustom.redirectToSignup() = SplashRedirectToSignup;
  const factory SplashCustom.redirectToAddMembers() = SplashRedirectToAddMembers;
  const factory SplashCustom.redirectToHome() = SplashRedirectToHome;
}

class SplashRedirectToWelcome extends SplashCustom {
  const SplashRedirectToWelcome();
}

class SplashRedirectToSignup extends SplashCustom {
  const SplashRedirectToSignup();
}

class SplashRedirectToAddMembers extends SplashCustom {
  const SplashRedirectToAddMembers();
}

class SplashRedirectToHome extends SplashCustom {
  const SplashRedirectToHome();
}
