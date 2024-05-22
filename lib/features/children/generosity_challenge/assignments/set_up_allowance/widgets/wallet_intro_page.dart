import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WalletIntroPage extends StatelessWidget {
  const WalletIntroPage({required this.onContinue, super.key});
  final VoidCallback onContinue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text(
                'The Wallet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'The Mayor has given each child their own Wallet that can be found in Givt4Kids.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Afterwards you can download the app so they can continue their giving journey.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Expanded(
                child: SvgPicture.asset('assets/images/generosity_wallet.svg'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
