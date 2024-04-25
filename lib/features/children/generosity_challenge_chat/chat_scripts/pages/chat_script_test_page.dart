import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/cubit/chat_scripts_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/day_chat_status.dart';
import 'package:givt_app/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';

class ChatScriptTestPage extends StatelessWidget {
  const ChatScriptTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatScriptsCubit, ChatScriptsState>(
      listener: (BuildContext context, ChatScriptsState state) {
        if (state.status == ChatScriptsStatus.error) {
          SnackBarHelper.showMessage(context, text: state.error, isError: true);
        }
        if (state.status == ChatScriptsStatus.updated) {
          // SnackBarHelper.showMessage(
          //   context,
          //   text: state.chatScriptHead.toString(),
          // );
        }
      },
      builder: (BuildContext context, ChatScriptsState state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('ChatScriptTestPage'),
          ),
          body: state.status == ChatScriptsStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  color: Colors.green,
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: GivtElevatedButton(
            onTap: () {
              context.read<ChatScriptsCubit>().updateDayChatStatus(
                    dayIndex: 0,
                    dayChatStatus: DayChatStatus.active,
                  );
            },
            text: 'Test',
          ),
        );
      },
    );
  }
}
