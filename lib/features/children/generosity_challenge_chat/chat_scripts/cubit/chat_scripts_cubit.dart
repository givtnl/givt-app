import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/day_chat_status.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/repositories/chat_script_interpreter_repository.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/repositories/chat_scripts_repository.dart';

part 'chat_scripts_state.dart';

class ChatScriptsCubit extends Cubit<ChatScriptsState> {
  ChatScriptsCubit(
    this._chatScriptsRepository,
    this._chatScriptInterpreterRepository,
  ) : super(const ChatScriptsState.initial());

  static const int chatScriptsAmount = 1;

  final ChatScriptsRepository _chatScriptsRepository;
  final ChatScriptInterpreterRepository _chatScriptInterpreterRepository;

  Future<void> preload() async {
    await loadScripts();
    await refreshChatStatuses();
  }

  Future<void> loadScripts() async {
    emit(state.copyWith(status: ChatScriptsStatus.loading));

    // await Future.delayed(Duration(seconds: 1));

    try {
      final chatScripts = <ChatScriptItem>[];
      for (var dayIndex = 0; dayIndex < chatScriptsAmount; dayIndex++) {
        chatScripts.add(
          await _chatScriptsRepository.loadChatScript(
            chatScriptIndex: dayIndex,
          ),
        );
      }

      emit(
        state.copyWith(
          status: ChatScriptsStatus.updated,
          chatScripts: chatScripts,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ChatScriptsStatus.error,
          error: error.toString(),
        ),
      );
    }
  }

  Future<void> refreshChatStatuses({
    bool interpret = false,
  }) async {
    emit(state.copyWith(status: ChatScriptsStatus.loading));

    try {
      final dayChatStatuses = <DayChatStatus>[];
      for (var dayIndex = 0; dayIndex < chatScriptsAmount; dayIndex++) {
        dayChatStatuses.add(
          _chatScriptInterpreterRepository.getDayChatStatus(
            dayIndex: dayIndex,
          ),
        );
      }

      emit(
        state.copyWith(
          status: ChatScriptsStatus.updated,
          dayChatStatuses: dayChatStatuses,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ChatScriptsStatus.error,
          error: error.toString(),
        ),
      );
    }

    if (interpret && state.activeDayChatIndex >= 0) {
      await _interpretScript();
    }
  }

  Future<void> updateDayChatStatus({
    required int dayIndex,
    required DayChatStatus dayChatStatus,
  }) async {
    await _chatScriptInterpreterRepository.updateDayChatStatus(
      dayIndex: dayIndex,
      dayChatStatus: dayChatStatus,
    );
    await refreshChatStatuses(interpret: true);
  }

  Future<void> _interpretScript() async {
    // var currentItem
  }
}
