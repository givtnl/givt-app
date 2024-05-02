import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_actors_settings.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/day_chat_state.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_functions.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_item_type.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/day_chat_status.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/repositories/chat_script_interpreter_repository.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/repositories/chat_scripts_repository.dart';
import 'package:givt_app/utils/utils.dart';

part 'chat_scripts_state.dart';

class ChatScriptsCubit extends Cubit<ChatScriptsState> {
  ChatScriptsCubit(
    this._chatScriptsRepository,
    this._chatScriptInterpreterRepository,
  ) : super(const ChatScriptsState.initial());

  static const Duration _typingDuration = Duration(milliseconds: 1500);

  final ChatScriptsRepository _chatScriptsRepository;
  final ChatScriptInterpreterRepository _chatScriptInterpreterRepository;

  Future<void> init(BuildContext context) async {
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

      if (context.mounted) {
        await _interpretScript(context);
      }
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
        status: ChatScriptsStatus.updated,
        gainedAnswer: const ChatScriptItem.empty(),
      ),
    );
  }

  Future<void> activateChat(
    BuildContext context, {
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
    if (context.mounted) {
      await _interpretScript(context);
    }
  }

  Future<void> provideAnswer(
    BuildContext context, {
    required ChatScriptItem answer,
  }) async {
    emit(
      state.copyWith(
        status: ChatScriptsStatus.updated,
        gainedAnswer: answer,
      ),
    );
    await _interpretScript(context);
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
    );
    await _chatScriptInterpreterRepository
        .saveDayChatStates(state.dayChatStates);

    emit(state.copyWith(dayChatStates: state.dayChatStates));
  }

  Future<void> _interpretScript(BuildContext context) async {
    if (state.activeDayChatIndex >= 0) {
      final isContinuing =
          state.dayChatStates[state.activeDayChatIndex].currentItem !=
              const ChatScriptItem.empty();
      ChatScriptItem? currentChatItem = isContinuing
          ? state.dayChatStates[state.activeDayChatIndex].currentItem
          : state.chatScripts[state.activeDayChatIndex];

      if (!isContinuing) {
        await _addDelimiter();
      }

      for (; currentChatItem != null; currentChatItem = currentChatItem.next) {
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
          await Future.delayed(_typingDuration, () {});

          newHead = state.chatHistory.replaceHead(head: currentChatItem);
        } else if (currentChatItem.isCondition &&
            state.gainedAnswer != const ChatScriptItem.empty()) {
          final amplitudeEvent = state.gainedAnswer.amplitudeEvent;
          if (amplitudeEvent.isNotEmpty) {
            await AnalyticsHelper.logChatScriptEvent(
              eventName: amplitudeEvent,
              eventProperties: {
                'value': state.gainedAnswer.answerText,
              },
            );
          }

          if (state.gainedAnswer.isHidden) {
            newHead = state.chatHistory;
          } else {
            newHead = state.chatHistory.addHead(
              head: state.gainedAnswer.copyWith(
                type: ChatScriptItemType.textMessage,
                text: state.gainedAnswer.answerText,
              ),
            );
          }
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
              .copyWith(currentItem: currentChatItem.next),
        );

        if (currentChatItem.hasFunction) {
          final itemFunction =
              ChatScriptFunctions.fromString(currentChatItem.functionName);

          if (context.mounted) {
            await itemFunction.function(context);
          }
        }
      }

      await _completeDayChat();
    }
  }
}
