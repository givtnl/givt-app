import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/cubit/chat_scripts_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_item_type.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/widgets/chat_input_field.dart';
import 'package:givt_app/shared/widgets/givt_elevated_button.dart';

class ChatBar extends StatelessWidget {
  const ChatBar({
    super.key,
  });

  static const double chatBarHeight = 140;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatScriptsCubit, ChatScriptsState>(
      builder: (BuildContext context, ChatScriptsState state) {
        return Container(
          height: chatBarHeight,
          color: Colors.white,
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
            child: GivtElevatedButton(
              onTap: () {
                context
                    .read<ChatScriptsCubit>()
                    .provideAnswer(answer: state.currentConditionalItem);
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
                answer:
                    state.currentConditionalItem.copyWith(answerText: value),
              );
        },
      );
    }
    return const SizedBox.shrink();
  }
}
