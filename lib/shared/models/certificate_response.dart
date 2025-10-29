import 'package:equatable/equatable.dart';

class CertificateResponse extends Equatable {
  const CertificateResponse({
    required this.token,
    required this.apiURL,
  });

  final String token;
  final String apiURL;

  @override
  List<Object?> get props => [
        token,
        apiURL,
      ];
}
