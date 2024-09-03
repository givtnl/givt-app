import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/cubit/chat_scripts_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_item_type.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/widgets/chat_input_field.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/widgets/buttons/fun_button.dart';

class ChatBar extends StatelessWidget {
  const ChatBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatScriptsCubit, ChatScriptsState>(
      builder: (BuildContext context, ChatScriptsState state) {
        return Container(
          padding: const EdgeInsets.only(left: 24, right: 24),
          alignment: Alignment.bottomCenter,
          child: state.status == ChatScriptsStatus.waitingForAnswer
              ? _createAnswerWidgetByType(context, state)
              : const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _createAnswerWidgetByType(
    BuildContext context,
    ChatScriptsState state,
  ) {
    if (state.currentConditionalItem.type == ChatScriptItemType.buttonAnswer) {
      return Row(
        children: [
          const Spacer(flex: 2),
          Flexible(
            flex: 5,
            child: FunButton(
              onTap: () {
                context.read<ChatScriptsCubit>().provideAnswer(
                      context,
                      answer: state.currentConditionalItem,
                    );
              },
              text: state.currentConditionalItem.text,
            ),
          ),
        ],
      );
    } else if (state.currentConditionalItem.type ==
        ChatScriptItemType.inputAnswer) {
      return ChatInputField(
        chatItem: state.currentConditionalItem,
        onComplete: (String value) {
          context.read<ChatScriptsCubit>().provideAnswer(
                context,
                answer:
                    state.currentConditionalItem.copyWith(answerText: value),
              );
        },
      );
    } else if (state.currentConditionalItem.type ==
        ChatScriptItemType.buttonGroupAnswer) {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                context.read<ChatScriptsCubit>().provideAnswer(
                      context,
                      answer: state.currentConditionalItem.options[0],
                    );
              },
              child: Text(
                state.currentConditionalItem.options[0].text,
                textAlign: TextAlign.center,
                style: const FamilyAppTheme().toThemeData().textTheme.labelLarge,
              ),
            ),
          ),
          Expanded(
            child: FunButton(
              onTap: () {
                context.read<ChatScriptsCubit>().provideAnswer(
                      context,
                      answer: state.currentConditionalItem.options[1],
                    );
              },
              text: state.currentConditionalItem.options[1].text,
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
