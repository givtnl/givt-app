import 'package:flutter/material.dart';

class PermissionsUIModel {
  const PermissionsUIModel({
    required this.body,
    required this.title,
    required this.image,
    required this.onNextTap,
    this.isSettings = false,
  });

  final bool isSettings;
  final String body;
  final String title;
  final Widget image;
  final VoidCallback onNextTap;
}
