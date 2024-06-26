import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';

class WalletIntroPage extends StatelessWidget {
  const WalletIntroPage({required this.onContinue, super.key,});
  final VoidCallback onContinue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'The Wallet',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'The Mayor has gifted each child their own Wallet.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'They can use the money to discover different ways to spread generosity.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Expanded(
                child: SvgPicture.asset('assets/images/generosity_wallet.svg'),
              ),
              CustomGreenElevatedButton(
                onPressed: onContinue,
                title: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
