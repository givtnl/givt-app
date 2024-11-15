sealed class EmailSignupCustom {
  const EmailSignupCustom();

  const factory EmailSignupCustom.checkingEmail() = EmailSignupCheckingEmail;
  const factory EmailSignupCustom.registerFamily(String email) =
      EmailSignupShowFamilyRegistration;
  const factory EmailSignupCustom.loginFamily(String email) =
      EmailSignupShowFamilyLogin;
  const factory EmailSignupCustom.noInternet() = EmailSignupNoInternet;
  const factory EmailSignupCustom.certExpired() = EmailSignupCertExpired;
}

class EmailSignupCheckingEmail extends EmailSignupCustom {
  const EmailSignupCheckingEmail();
}

class EmailSignupShowFamilyRegistration extends EmailSignupCustom {
  const EmailSignupShowFamilyRegistration(this.email);

  final String email;
}

class EmailSignupShowFamilyLogin extends EmailSignupCustom {
  const EmailSignupShowFamilyLogin(this.email);

  final String email;
}

class EmailSignupNoInternet extends EmailSignupCustom {
  const EmailSignupNoInternet();
}

class EmailSignupCertExpired extends EmailSignupCustom {
  const EmailSignupCertExpired();
}