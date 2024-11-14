sealed class UsSignupCustom {
  const UsSignupCustom();

  const factory UsSignupCustom.redirectToAddMembers() =
      UsSignupRedirectToAddMembers;
  const factory UsSignupCustom.redirectToHome() =
      UsSignupRedirectToHome;
}

class UsSignupRedirectToAddMembers extends UsSignupCustom {
  const UsSignupRedirectToAddMembers();
}

class UsSignupRedirectToHome extends UsSignupCustom {
  const UsSignupRedirectToHome();
}
