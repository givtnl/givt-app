import 'package:equatable/equatable.dart';

class MandateSignatureFailure extends Equatable implements Exception {
  const MandateSignatureFailure({
    required this.statusCode,
    this.body,
  });

  final int statusCode;
  final Map<String, dynamic>? body;

  @override
  List<Object> get props => [statusCode];
}
