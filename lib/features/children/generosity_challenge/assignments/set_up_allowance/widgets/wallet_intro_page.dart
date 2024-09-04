import 'package:flutter/material.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';

class WalletIntroPage extends StatelessWidget {
  const WalletIntroPage({
    required this.onContinue,
    super.key,
  });
  final VoidCallback onContinue;
  @override
  Widget build(BuildContext context) {
    final theme = const FamilyAppTheme().toThemeData();
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: const GenerosityAppBar(
          title: 'Gift from the Mayor',
          leading: GenerosityBackButton(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                Stack(
                  children: [
                    const Align(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: FamilyAppTheme.primary95,
                        ),
                      ),
                    ),
                    Align(
                      child: walletIcon(width: 140, height: 140),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'The Wallet',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'The Mayor has given each child a wallet. Parents can add money to it so the children can learn and practice generosity.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
                const Spacer(flex: 2),
                FunButton(
                  onTap: onContinue,
                  text: 'Continue',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
