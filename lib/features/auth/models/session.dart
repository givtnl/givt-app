class Session {
  Session({
    required this.email,
    required this.userGUID,
    required this.accessToken,
    required this.refreshToken,
    required this.expires,
    required this.expiresIn,
  });

  factory Session.fromLoginData(
    String userGUID,
    String email,
    String accessToken,
    String refreshToken,
    String expires,
    int expiresIn,
  ) {
    return Session(
      userGUID: userGUID,
      email: email,
      accessToken: accessToken,
      expires: expires,
      expiresIn: expiresIn,
      refreshToken: refreshToken,
    );
  }

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        email: json['Email'] as String,
        userGUID: json['GUID'] as String,
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String,
        expires: json['.expires'] as String,
        expiresIn: 0,
      );
  const Session.empty()
      : userGUID = '',
        email = '',
        accessToken = '',
        refreshToken = '',
        expires = '',
        expiresIn = 0;

  final String userGUID;
  final String email;
  final String accessToken;
  final String refreshToken;
  final String expires;
  final int expiresIn;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'GUID': userGUID,
        'Email': email,
        'access_token': accessToken,
        'refresh_token': refreshToken,
        '.expires': expires,
        'expires_In': expiresIn,
      };

  static String tag = 'Session';
}
