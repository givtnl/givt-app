// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';

class GivtServerFailure extends Equatable implements Exception {
  const GivtServerFailure({
    required this.statusCode,
    this.body,
  });

  final int statusCode;
  final Map<String, dynamic>? body;

  FailureType get type {
    if (body != null) {
      final errorMessage = (body!['errorMessage'] ?? '').toString();
      return FailureType.getByErrorMessage(errorMessage);
    }
    return FailureType.UNKNOWN;
  }

  @override
  List<Object> get props => [statusCode, type];
}

enum FailureType {
  ALLOWANCE_NOT_SUCCESSFUL,
  VPC_NOT_SUCCESSFUL,
  UNKNOWN,
  ;

  static FailureType getByErrorMessage(String message) {
    try {
      return FailureType.values.byName(message);
    } catch (e) {
      return FailureType.UNKNOWN;
    }
  }
}
