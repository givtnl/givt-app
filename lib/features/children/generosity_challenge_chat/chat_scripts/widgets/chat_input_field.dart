import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/widgets/givt_icon_button.dart';
import 'package:givt_app/utils/utils.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({
    required this.chatItem,
    required this.onComplete,
    super.key,
  });

  final ChatScriptItem chatItem;
  final void Function(String value) onComplete;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  late final TextEditingController _textController;

  final focusNode = FocusNode();

  String inputText = '';

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    _textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _onComplete() {
    widget.onComplete(inputText);
    setState(() {
      inputText = '';
      _textController.text = inputText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _textController,
            focusNode: focusNode,
            // inputFormatters: [],
            textInputAction: TextInputAction.done,
            // keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                inputText = value.trim();
              });
            },
            onEditingComplete: _onComplete,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 20,
                  fontFamily: 'Rouna',
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary20,
                ),

            decoration: InputDecoration(
              hintText: widget.chatItem.text,
              hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 20,
                    fontFamily: 'Rouna',
                    fontWeight: FontWeight.w700,
                    //TODO: replace with neutralVariant40
                    color: AppTheme.neutralVariant50,
                  ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppTheme.inputFieldBorderEnabled,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppTheme.inputFieldBorderSelected,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GivtIconButton(
          isDisabled: inputText.isEmpty,
          iconData: FontAwesomeIcons.paperPlane,
          onTap: _onComplete,
        ),
      ],
    );
  }
}
