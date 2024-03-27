import 'package:flutter/material.dart';

class PermitBiometricRequest {
  const PermitBiometricRequest({
    required this.redirect,
    this.isRegistration = true,
  });

  final bool isRegistration;
  final void Function(BuildContext context) redirect;
}
