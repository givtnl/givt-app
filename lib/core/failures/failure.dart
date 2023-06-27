import 'package:equatable/equatable.dart';

class GivtServerFailure extends Equatable implements Exception {
  const GivtServerFailure({
    required this.statusCode,
    this.body,
  });

  final int statusCode;
  final Map<String, dynamic>? body;

  @override
  List<Object> get props => [statusCode];
}
