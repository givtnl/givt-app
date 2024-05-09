import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_input_answer_type.dart';
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
  String errorMessage = '';

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

  bool _isValidInput(String input, ChatScriptInputAnswerType type) {
    switch (type) {
      case ChatScriptInputAnswerType.email:
        final isValid = Util.emailRegEx.hasMatch(input);
        if (!isValid) {
          setState(() {
            errorMessage = 'Not a valid email address.';
          });
        }
        return isValid;
      case ChatScriptInputAnswerType.text:
        final isValid = Util.nameFieldsRegEx.hasMatch(input);
        if (!isValid) {
          setState(() {
            errorMessage = 'Input contains invalid characters.';
          });
        }
        return isValid;
      case ChatScriptInputAnswerType.password:
        final isLongEnough = input.length > 6;
        if (!isLongEnough) {
          setState(() {
            errorMessage = 'Must contain at least 6 charachters.';
          });
        }
        final containsNumber = input.contains(RegExp('[0-9]'));
        if (!containsNumber) {
          setState(() {
            errorMessage = 'Must contain one number.';
          });
        }
        final containsCaptialLetter = input.contains(RegExp('[A-Z]'));
        if (!containsCaptialLetter) {
          setState(() {
            errorMessage = 'Must contain at least one capital letter.';
          });
        }
        return isLongEnough && containsNumber && containsCaptialLetter;
      case ChatScriptInputAnswerType.number:
        final isValid = Util.numberInputFieldRegExp().hasMatch(input);
        if (!isValid) {
          setState(() {
            errorMessage = 'Only numeric characters please.';
          });
        }
        return isValid;
      case ChatScriptInputAnswerType.none:
        return false;
    }
  }

  void _onComplete() {
    if (_isValidInput(inputText, widget.chatItem.inputAnswerType)) {
      widget.onComplete(inputText);
      setState(() {
        inputText = '';
        _textController.text = inputText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.chatItem.inputAnswerType ==
            ChatScriptInputAnswerType.password)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'It must contain at least 7 characters\nincluding at least one capital and one digit.',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontFamily: 'Rouna',
                    color: AppTheme.givtBlue,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                focusNode: focusNode,
                textInputAction: TextInputAction.done,
                keyboardType: widget.chatItem.inputAnswerType ==
                        ChatScriptInputAnswerType.number
                    ? TextInputType.number
                    : TextInputType.text,
                obscureText: widget.chatItem.inputAnswerType ==
                    ChatScriptInputAnswerType.password,
                obscuringCharacter: '*',
                onChanged: (value) {
                  setState(() {
                    inputText = value.trim();
                  });
                  if (errorMessage.isNotEmpty) {
                    if (_isValidInput(
                        inputText, widget.chatItem.inputAnswerType)) {
                      setState(() {
                        errorMessage = '';
                      });
                    }
                  }
                },
                onEditingComplete: _onComplete,
                style: textStyle?.copyWith(
                  color: AppTheme.primary20,
                ),
                decoration: InputDecoration(
                  hintText: widget.chatItem.text,
                  hintStyle: textStyle?.copyWith(
                    color: AppTheme.neutralVariant40,
                  ),
                  enabledBorder: buildInputBorder.copyWith(
                    borderSide: borderSide.copyWith(
                      color: AppTheme.inputFieldBorderEnabled,
                    ),
                  ),
                  focusedErrorBorder: buildInputBorder.copyWith(
                    borderSide: borderSide.copyWith(
                      color: AppTheme.error50,
                    ),
                  ),
                  errorText: errorMessage.isNotEmpty ? errorMessage : null,
                  focusedBorder: buildInputBorder.copyWith(
                    borderSide: borderSide.copyWith(
                      color: AppTheme.inputFieldBorderSelected,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding:
                  EdgeInsets.only(bottom: errorMessage.isNotEmpty ? 22 : 0),
              child: GivtIconButton(
                isDisabled: inputText.isEmpty,
                iconData: FontAwesomeIcons.paperPlane,
                onTap: _onComplete,
              ),
            ),
          ],
        ),
      ],
    );
  }

  TextStyle? get textStyle => Theme.of(context).textTheme.titleLarge?.copyWith(
        fontFamily: 'Rouna',
        fontWeight: FontWeight.w700,
        color: AppTheme.primary20,
      );

  BorderSide get borderSide => const BorderSide(
        color: AppTheme.inputFieldBorderSelected,
        width: 2,
      );

  InputBorder get buildInputBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: borderSide,
      );
}
