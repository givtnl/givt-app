import 'package:flutter/material.dart';

class EditAllowancePage extends StatefulWidget {
  const EditAllowancePage({super.key});

  @override
  State<EditAllowancePage> createState() => _EditAllowancePageState();
}

class _EditAllowancePageState extends State<EditAllowancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          BackButton(),
        ],
      ),
      body: const SizedBox(),
    );
  }
}
