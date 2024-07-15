import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/cubit/chat_scripts_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/widgets/chat_bar.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/widgets/chat_history.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ChatScriptPage extends StatefulWidget {
  const ChatScriptPage({
    super.key,
  });

  @override
  State<ChatScriptPage> createState() => _ChatScriptPageState();
}

class _ChatScriptPageState extends State<ChatScriptPage> {
  final AppConfig _appConfig = getIt();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatScriptsCubit, ChatScriptsState>(
      listener: (BuildContext context, ChatScriptsState state) {
        if (state.status == ChatScriptsStatus.error) {
          SnackBarHelper.showMessage(context, text: state.error, isError: true);
        }
      },
      builder: (BuildContext context, ChatScriptsState state) {
        //do not show back for the first day chat after intro
        final showBackButton = context
                .read<GenerosityChallengeCubit>()
                .state
                .availableChatDayIndex !=
            0;
        return Scaffold(
          backgroundColor: AppTheme.primary99,
          appBar: GenerosityAppBar(
            title: 'Chat',
            leading: showBackButton ? const GenerosityBackButton() : null,
            actions: [
              if (_appConfig.isTestApp)
                Opacity(
                  opacity: 0.1,
                  child: IconButton(
                    onPressed: () {
                      context.read<ChatScriptsCubit>().clearChatHistory();
                      context.pop();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
            ],
          ),
          body: SafeArea(
            minimum: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                Expanded(
                  child: state.status == ChatScriptsStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : const ChatHistory(),
                ),
                const ChatBar(),
              ],
            ),
          ),
        );
      },
    );
  }
}
