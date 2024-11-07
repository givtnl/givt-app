import 'package:givt_app/core/enums/country.dart';

sealed class EmailSignupCustom {
  const EmailSignupCustom();

  const factory EmailSignupCustom.success(String email, Country country) =
      EmailSignupSuccess;
  const factory EmailSignupCustom.successFamily(String email) =
      EmailSignupSuccessFamily;
  const factory EmailSignupCustom.noInternet() = EmailSignupNoInternet;
  const factory EmailSignupCustom.certExpired() = EmailSignupCertExpired;
}

class EmailSignupSuccess extends EmailSignupCustom {
  const EmailSignupSuccess(this.email, this.country);

  final String email;
  final Country country;
}

class EmailSignupSuccessFamily extends EmailSignupCustom {
  const EmailSignupSuccessFamily(this.email);

  final String email;
}

class EmailSignupNoInternet extends EmailSignupCustom {
  const EmailSignupNoInternet();
}

class EmailSignupCertExpired extends EmailSignupCustom {
  const EmailSignupCertExpired();
}
