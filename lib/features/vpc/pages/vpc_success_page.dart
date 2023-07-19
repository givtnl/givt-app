import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';

class VPCSuccessPage extends StatelessWidget {
  const VPCSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 35),
        width: double.infinity,
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: size.height * 0.035,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              height: size.height * 0.85,
              child: SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locals.vpcSuccessText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: AppTheme.sliderIndicatorFilled),
                    ),
                    Image.asset(
                      'assets/images/vpc_givy.png',
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        locals.setupChildProfileButtonText,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
