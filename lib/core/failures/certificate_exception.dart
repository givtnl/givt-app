import 'package:equatable/equatable.dart';

class CertificatesException extends Equatable implements Exception {
  const CertificatesException({
    this.message,
  });

  final String? message;

  @override
  List<Object> get props => [message ?? ''];
}
