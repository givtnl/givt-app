import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';

class BTScanPage extends StatelessWidget {
  const BTScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(locals.giveWithYourPhone),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text(
              locals.makeContact,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/givt_animation.gif',
                // width: size.width * 0.5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
