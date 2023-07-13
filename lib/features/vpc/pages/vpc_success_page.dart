import 'package:flutter/material.dart';

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
                      const Text(
                        "Great! Now you have given VPC, let’s get your children's profiles set up!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF184869),
                        ),
                      ),
                      Image.asset(
                        'assets/images/vpc_givy.png',
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Set up child profile(s)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                          ),
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
