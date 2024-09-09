class Session {
  Session({
    required this.email,
    required this.userGUID,
    required this.accessToken,
    required this.refreshToken,
    required this.expires,
    required this.expiresIn,
    required this.isLoggedIn,
  });

  factory Session.fromLoginData(
    String userGUID,
    String email,
    String accessToken,
    String refreshToken,
    String expires,
    int expiresIn, {
    bool isLoggedIn = false,
  }) {
    return Session(
      userGUID: userGUID,
      email: email,
      accessToken: accessToken,
      expires: expires,
      expiresIn: expiresIn,
      refreshToken: refreshToken,
      isLoggedIn: isLoggedIn,
    );
  }

  factory Session.fromGenerosityJson(Map<String, dynamic> json) => Session(
        email: json['email'] as String,
        userGUID: json['userId'] as String,
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        expires: json['expirationDate'] as String,
        expiresIn: json['expiresIn'] as int,
        isLoggedIn: true,
      );

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        email: json['Email'] as String,
        userGUID: json['GUID'] as String,
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String,
        expires: json['.expires'] as String,
        expiresIn: 0,
        isLoggedIn:
            json.containsKey('isLoggedIn') ? json['isLoggedIn'] as bool : false,
      );
  const Session.empty()
      : userGUID = '',
        email = '',
        accessToken = '',
        refreshToken = '',
        expires = '',
        expiresIn = 0,
        isLoggedIn = false;

  final String userGUID;
  final String email;
  final String accessToken;
  final String refreshToken;
  final String expires;
  final int expiresIn;
  final bool isLoggedIn;

  Session copyWith({
    String? email,
    String? userGUID,
    String? accessToken,
    String? refreshToken,
    String? expires,
    int? expiresIn,
    bool? isLoggedIn,
  }) =>
      Session(
        email: email ?? this.email,
        userGUID: userGUID ?? this.userGUID,
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        expires: expires ?? this.expires,
        expiresIn: expiresIn ?? this.expiresIn,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      );

  bool get isExpired {
    final now = DateTime.now().toUtc();

    /// If the expires date is empty, then ask user to login.
    if (expires.isEmpty) return true;
    final expiresDate = DateTime.parse(expires).subtract(
      const Duration(
        minutes: 20,
      ),
    );
    return now.isAfter(expiresDate);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'GUID': userGUID,
        'Email': email,
        'access_token': accessToken,
        'refresh_token': refreshToken,
        '.expires': expires,
        'expires_In': expiresIn,
        'isLoggedIn': isLoggedIn,
      };

  @override
  String toString() {
    return 'Session{userGUID: $userGUID, email: $email, accessToken: $accessToken, refreshToken: $refreshToken, expires: $expires, expiresIn: $expiresIn, isLoggedIn: $isLoggedIn}';
  }

  static String tag = 'Session';
}
