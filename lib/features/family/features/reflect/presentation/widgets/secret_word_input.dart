import 'package:flutter/material.dart';

class SecretWordInput extends StatefulWidget {
  const SecretWordInput({
    required this.amountOfLetters,
    required this.onChanged,
    super.key,
  });

  final int amountOfLetters;
  final void Function(String word) onChanged;

  @override
  State<SecretWordInput> createState() => _SecretWordInputState();
}

class _SecretWordInputState extends State<SecretWordInput> {
  List<FocusNode> focusNodes = [];
  List<TextEditingController> controllers = [];

  @override
  Widget build(BuildContext context) {
    focusNodes = List.generate(widget.amountOfLetters, (index) => FocusNode());

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < widget.amountOfLetters; i++) ...[
          SizedBox(
            width: 16,
            child: TextField(
              focusNode: focusNodes[i],
              textAlign: TextAlign.center,
              maxLength: 1,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  focusNodes[i].unfocus();
                  if (i < widget.amountOfLetters - 1) {
                    focusNodes[i + 1].requestFocus();
                  }
                } else {
                  if (i > 0) focusNodes[i - 1].requestFocus();
                }

                widget.onChanged(getWord());
              },
            ),
          ),
          if (i < widget.amountOfLetters - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }

  String getWord() {
    return controllers.map((e) => e.text).join();
  }
}
