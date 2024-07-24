import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_input_answer_type.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/widgets/givt_icon_button.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
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

  bool _passwordVisible = false;

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
        return Util.emailRegEx.hasMatch(input);
      case ChatScriptInputAnswerType.text:
        return Util.nameFieldsRegEx.hasMatch(input);
      case ChatScriptInputAnswerType.password:
        final isLongEnough = input.length > 6;
        final containsNumber = input.contains(RegExp('[0-9]'));
        final containsCaptialLetter = input.contains(RegExp('[A-Z]'));

        return isLongEnough && containsNumber && containsCaptialLetter;
      case ChatScriptInputAnswerType.number:
        return Util.numberInputFieldRegExp().hasMatch(input);
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
                        ChatScriptInputAnswerType.password &&
                    !_passwordVisible,
                obscuringCharacter: '*',
                onChanged: (value) {
                  setState(() {
                    inputText = value.trim();
                  });
                  if (errorMessage.isNotEmpty) {
                    if (_isValidInput(
                      inputText,
                      widget.chatItem.inputAnswerType,
                    )) {
                      setState(() {
                        errorMessage = '';
                      });
                    }
                  }
                },
                onEditingComplete: _onComplete,
                style: textStyle,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: widget.chatItem.text,
                  hintStyle: textStyle?.copyWith(
                    color: AppTheme.neutralVariant40,
                  ),
                  enabledBorder: buildInputBorder.copyWith(
                    borderSide: borderSide.copyWith(
                      color: AppTheme.inputFieldBorderEnabled,
                    ),
                  ),
                  focusedBorder: buildInputBorder.copyWith(
                    borderSide: borderSide.copyWith(
                      color: AppTheme.inputFieldBorderEnabled,
                    ),
                  ),
                  suffixIcon: widget.chatItem.inputAnswerType ==
                          ChatScriptInputAnswerType.password
                      ? IconButton(
                          icon: FaIcon(
                            _passwordVisible
                                ? FontAwesomeIcons.solidEyeSlash
                                : FontAwesomeIcons.solidEye,
                            color: AppTheme.primary30,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            GivtIconButton(
              isDisabled: inputText.isEmpty ||
                  !_isValidInput(inputText, widget.chatItem.inputAnswerType),
              iconData: FontAwesomeIcons.paperPlane,
              onTap: _onComplete,
            ),
          ],
        ),
      ],
    );
  }

  TextStyle? get textStyle =>
      FamilyAppTheme().toThemeData().textTheme.titleSmall?.copyWith(
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
