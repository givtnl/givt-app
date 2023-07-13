import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

class VPCSuccessPage extends StatelessWidget {
  const VPCSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                        "Great! Now you have given VPC, let’s get your children's profiles set up!",
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
                          'Set up child profile(s)',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
