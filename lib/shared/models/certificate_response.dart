import 'package:equatable/equatable.dart';

class CertificateResponse extends Equatable {
  const CertificateResponse({
    required this.token,
    required this.apiURL,
    required this.apiURLAWS,
  });

  final String token;
  final String apiURL;
  final String apiURLAWS;

  @override
  List<Object?> get props => [
        token,
        apiURL,
        apiURLAWS,
      ];
}
