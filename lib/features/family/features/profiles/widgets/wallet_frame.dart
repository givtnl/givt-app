import 'package:flutter/material.dart';

class WalletFrame extends StatelessWidget {
  const WalletFrame({
    required this.body, super.key,
  });
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: size.width * 0.08, horizontal: 24),
          child: body,
        ),
      ),
    );
  }
}
