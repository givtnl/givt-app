import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_functions.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_item_type.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/repositories/chat_history_repository.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

part 'chat_scripts_state.dart';

class ChatScriptsCubit extends Cubit<ChatScriptsState> {
  ChatScriptsCubit(
    this._chatHistoryRepository, {
    required GenerosityChallengeCubit challengeCubit,
  })  : _challengeCubit = challengeCubit,
        super(const ChatScriptsState.initial()) {
    _challengeCubit.stream.listen((challengeState) {
      if (isClosed) {
        return;
      }
      emit(state.copyWith(availableChat: challengeState.availableChat));
    });
  }

  static const Duration _typingDuration = Duration(milliseconds: 1000);
  static const Duration _chatCompletedDelay = Duration(milliseconds: 3000);

  final ChatHistoryRepository _chatHistoryRepository;
  final GenerosityChallengeCubit _challengeCubit;

  Future<void> init(BuildContext context) async {
    emit(state.copyWith(status: ChatScriptsStatus.loading));

    try {
      final chatHistory = _chatHistoryRepository.loadChatHistory();

      final activeChat = _challengeCubit.state.availableChat;

      emit(
        state.copyWith(
          status: ChatScriptsStatus.updated,
          chatHistory: chatHistory,
          availableChat: activeChat,
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

  Future<void> clearChatHistory() async {
    await _chatHistoryRepository.saveChatHistory(const ChatScriptItem.empty());
    await _challengeCubit.clearCache();
    emit(const ChatScriptsState.initial());
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
        text: 'Day ${_challengeCubit.state.activeDayIndex + 1}',
      ),
    );
    await _chatHistoryRepository.saveChatHistory(delimiterHead);
    emit(state.copyWith(chatHistory: delimiterHead));
  }

  Future<void> _completeDayChat(BuildContext context) async {
    await _challengeCubit.onChatCompleted();

    await Future.delayed(_chatCompletedDelay, () {
      context.pop();
    });
  }

  Future<void> _interpretScript(BuildContext context) async {
    if (state.hasAvailableChat) {
      final isContinuing = _challengeCubit.state.isChatContinuing;
      ChatScriptItem? currentChatItem = isContinuing
          ? state.availableChat
          : _challengeCubit.state.availableChatOriginScript;

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

        await _chatHistoryRepository.saveChatHistory(newHead);
        emit(state.copyWith(chatHistory: newHead));

        if (currentChatItem.hasFunction) {
          final itemFunction =
              ChatScriptFunctions.fromString(currentChatItem.functionName);

          if (context.mounted) {
            await itemFunction.function(context);
          }
        }

        await _challengeCubit.updateActiveDayChat(currentChatItem.next);
      }
      if (context.mounted) {
        await _completeDayChat(context);
      }
    }
  }
}
