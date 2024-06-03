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
                'The Mayor has given each child their own Wallet that can be found in Givt4Kids.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Afterwards you can download the app so they can continue their giving journey.',
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
