import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';

class BACSExplanationPage extends StatelessWidget {
  const BACSExplanationPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const BACSExplanationPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(locals.bacsSetupTitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          Text(locals.bacsSetupBody),
        ]),
      ),
    );
  }
}
