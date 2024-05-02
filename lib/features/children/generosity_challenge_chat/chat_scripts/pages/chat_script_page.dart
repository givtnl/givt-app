import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/cubit/chat_scripts_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/widgets/chat_bar.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/widgets/chat_history.dart';
import 'package:givt_app/utils/utils.dart';

class ChatScriptPage extends StatelessWidget {
  const ChatScriptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatScriptsCubit, ChatScriptsState>(
      listener: (BuildContext context, ChatScriptsState state) {
        if (state.status == ChatScriptsStatus.error) {
          SnackBarHelper.showMessage(context, text: state.error, isError: true);
        }
      },
      builder: (BuildContext context, ChatScriptsState state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chat'),
            actions: [
              Opacity(
                opacity: 0.1,
                child: IconButton(
                  onPressed: () {
                    context.read<ChatScriptsCubit>().clearChatHistory();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              // IconButton(
              //   onPressed: () {
              //     context.read<ChatScriptsCubit>().activateChat(
              //           context,
              //           dayIndex: 2,
              //         );
              //   },
              //   icon: const Icon(Icons.start),
              // ),
            ],
          ),
          body: state.status == ChatScriptsStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : const ChatHistory(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: const ChatBar(),
        );
      },
    );
  }
}
