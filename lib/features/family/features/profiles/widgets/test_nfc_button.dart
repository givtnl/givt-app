import 'package:flutter/material.dart';
import 'package:givt_app/features/family/app/pages.dart';
import 'package:go_router/go_router.dart';

class TestNFCButton extends StatelessWidget {
  const TestNFCButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.pushNamed(FamilyPages.scanNFC.name),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.maxFinite, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text(
        'Scan NFC',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF1EAE2),
        ),
      ),
    );
  }
}
