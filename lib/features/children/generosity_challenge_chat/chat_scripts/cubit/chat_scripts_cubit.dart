import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_actors_settings.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/day_chat_state.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_item_type.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/day_chat_status.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/repositories/chat_script_interpreter_repository.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/repositories/chat_scripts_repository.dart';

part 'chat_scripts_state.dart';

class ChatScriptsCubit extends Cubit<ChatScriptsState> {
  ChatScriptsCubit(
    this._chatScriptsRepository,
    this._chatScriptInterpreterRepository,
  ) : super(const ChatScriptsState.initial());

  final ChatScriptsRepository _chatScriptsRepository;
  final ChatScriptInterpreterRepository _chatScriptInterpreterRepository;

  Future<void> init() async {
    emit(state.copyWith(status: ChatScriptsStatus.loading));

    try {
      final chatScripts = await _loadScripts();
      final chatActorsSettings = await _loadChatActorsSettings();
      final dayChatStates = await _loadDayChatStates();
      final chatHistory = _loadChatHistory();

      emit(
        state.copyWith(
          status: ChatScriptsStatus.updated,
          chatScripts: chatScripts,
          dayChatStates: dayChatStates,
          chatHistory: chatHistory,
          chatActorsSettings: chatActorsSettings,
        ),
      );

      await _interpretScript();
    } catch (error) {
      emit(
        state.copyWith(
          status: ChatScriptsStatus.error,
          error: error.toString(),
        ),
      );
    }
  }

  Future<List<ChatScriptItem>> _loadScripts() =>
      _chatScriptsRepository.loadChatScripts();

  Future<ChatActorsSettings> _loadChatActorsSettings() =>
      _chatScriptsRepository.loadChatActorsSettings();

  Future<List<DayChatState>> _loadDayChatStates() =>
      _chatScriptInterpreterRepository.loadDayChatStates();

  ChatScriptItem _loadChatHistory() =>
      _chatScriptInterpreterRepository.loadChatHistory();

  Future<void> clearChatHistory() async {
    await _chatScriptInterpreterRepository
        .saveChatHistory(const ChatScriptItem.empty());

    await _chatScriptInterpreterRepository.clearDayChatStates();
    final newDayChatStates = await _loadDayChatStates();

    emit(
      state.copyWith(
        chatHistory: const ChatScriptItem.empty(),
        dayChatStates: newDayChatStates,
      ),
    );
  }

  Future<void> activateChat({
    required int dayIndex,
  }) async {
    if (state.dayChatStates[dayIndex].status == DayChatStatus.completed) {
      return;
    }

    await _updateDayChat(
      dayIndex,
      state.dayChatStates[dayIndex].copyWith(
        status: DayChatStatus.active,
      ),
    );
    await _interpretScript();
  }

  Future<void> provideAnswer({required ChatScriptItem answer}) async {
    emit(
      state.copyWith(
        status: ChatScriptsStatus.updated,
        gainedAnswer: answer,
      ),
    );
    await _interpretScript();
  }

  Future<void> _addDelimiter() async {
    final delimiterHead = state.chatHistory.addHead(
      head: ChatScriptItem.delimiter(
        text: 'Day ${state.activeDayChatIndex + 1}',
      ),
    );
    await _chatScriptInterpreterRepository.saveChatHistory(delimiterHead);
    emit(state.copyWith(chatHistory: delimiterHead));
  }

  Future<void> _updateDayChat(int dayIndex, DayChatState dayChatState) async {
    state.dayChatStates[dayIndex] = dayChatState;
    await _chatScriptInterpreterRepository
        .saveDayChatStates(state.dayChatStates);

    emit(state.copyWith(dayChatStates: state.dayChatStates));
  }

  Future<void> _completeDayChat() async {
    state.dayChatStates[state.activeDayChatIndex] =
        state.dayChatStates[state.activeDayChatIndex].copyWith(
      status: DayChatStatus.completed,
      chatScriptItemIndex: -1,
    );
    await _chatScriptInterpreterRepository
        .saveDayChatStates(state.dayChatStates);

    emit(state.copyWith(dayChatStates: state.dayChatStates));
  }

  Future<void> _interpretScript() async {
    if (state.activeDayChatIndex >= 0) {
      ChatScriptItem? currentChatItem =
          state.chatScripts[state.activeDayChatIndex];

      for (var chatItemIndex = 0;
          currentChatItem != null;
          chatItemIndex++, currentChatItem = currentChatItem.next) {
        if (chatItemIndex <=
            state.dayChatStates[state.activeDayChatIndex].chatScriptItemIndex) {
          continue;
        }

        if (chatItemIndex == 0) {
          await _addDelimiter();
        }

        if (currentChatItem.isCondition) {
          if (state.gainedAnswer == const ChatScriptItem.empty()) {
            emit(
              state.copyWith(
                status: ChatScriptsStatus.waitingForAnswer,
                currentConditionalItem: currentChatItem,
              ),
            );
            return;
          }
        }

        final ChatScriptItem newHead;
        if (currentChatItem.isBubble) {
          final typingHead = state.chatHistory
              .addHead(head: ChatScriptItem.typing(side: currentChatItem.side));

          emit(state.copyWith(chatHistory: typingHead));
          await Future.delayed(const Duration(milliseconds: 1500), () {});

          newHead = state.chatHistory.replaceHead(head: currentChatItem);
        } else if (currentChatItem.isCondition &&
            state.gainedAnswer != const ChatScriptItem.empty()) {
          newHead = state.chatHistory.addHead(
            head: state.gainedAnswer.copyWith(
              type: ChatScriptItemType.textMessage,
              text: state.gainedAnswer.answerText,
            ),
          );
          currentChatItem = state.gainedAnswer;

          emit(state.copyWith(gainedAnswer: const ChatScriptItem.empty()));
        } else {
          newHead = state.chatHistory.addHead(head: currentChatItem);
        }

        await _chatScriptInterpreterRepository.saveChatHistory(newHead);
        emit(state.copyWith(chatHistory: newHead));

        await _updateDayChat(
          state.activeDayChatIndex,
          state.dayChatStates[state.activeDayChatIndex]
              .copyWith(chatScriptItemIndex: chatItemIndex),
        );
      }

      await _completeDayChat();
    }
  }
}
