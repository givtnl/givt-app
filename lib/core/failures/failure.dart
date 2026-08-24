// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:equatable/equatable.dart';

class GivtServerFailure extends Equatable implements Exception {
  const GivtServerFailure({
    required this.statusCode,
    this.body,
  });

  /// Builds a failure from an HTTP error response. An empty or non-JSON body
  /// (common for `/oauth2/token` 400/401) must not throw [FormatException].
  factory GivtServerFailure.fromHttpResponse({
    required int statusCode,
    required String body,
  }) {
    return GivtServerFailure(
      statusCode: statusCode,
      body: _tryDecodeJsonMap(body),
    );
  }

  final int statusCode;
  final Map<String, dynamic>? body;

  FailureType get type {
    if (body != null) {
      final errorMessage = (body!['errorMessage'] ?? '').toString();
      return FailureType.getByErrorMessage(errorMessage);
    }
    return FailureType.UNKNOWN;
  }

  /// OAuth `/oauth2/token` returns `{"error":"invalid_grant"}` when the
  /// refresh token is expired or revoked.
  bool get isInvalidGrant {
    final oauthError = body?['error']?.toString() ?? '';
    if (oauthError == 'invalid_grant') {
      return true;
    }
    return body?.toString().contains('invalid_grant') ?? false;
  }

  /// Refresh cannot continue: JSON `invalid_grant`, or a 400/401 from the
  /// token endpoint (often with an empty body). Reliable only when the
  /// request sent `Authorization: Bearer` — without it, a still-valid
  /// refresh token produces the same empty 400/401. Callers must log the
  /// user out instead of showing a dismissible login sheet.
  bool get isRejectedOAuthToken {
    if (isInvalidGrant) {
      return true;
    }
    return statusCode == 400 || statusCode == 401;
  }

  @override
  List<Object> get props => [statusCode, type];

  @override
  String toString() =>
      'GivtServerFailure(statusCode: $statusCode, body: $body)';
}

Map<String, dynamic>? _tryDecodeJsonMap(String body) {
  if (body.isEmpty) {
    return null;
  }
  try {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return {'raw': decoded.toString()};
  } on FormatException {
    return {'raw': body};
  }
}

enum FailureType {
  ALLOWANCE_NOT_SUCCESSFUL,
  TOPUP_NOT_SUCCESSFUL,
  VPC_NOT_SUCCESSFUL,
  UNKNOWN;

  static FailureType getByErrorMessage(String message) {
    try {
      return FailureType.values.byName(message);
    } catch (e) {
      return FailureType.UNKNOWN;
    }
  }
}
