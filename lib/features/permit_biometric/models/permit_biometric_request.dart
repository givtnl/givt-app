import 'package:flutter/material.dart';

class PermitBiometricRequest {
  PermitBiometricRequest.registration({
    required this.redirect,
  }) : isRegistration = true;

  PermitBiometricRequest.login()
      : isRegistration = false,
        redirect = _emptyRedirect;

  static void _emptyRedirect(BuildContext context) {}

  bool get isRedirect {
    return redirect != _emptyRedirect;
  }

  final bool isRegistration;
  final void Function(BuildContext context) redirect;
}
