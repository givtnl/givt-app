part of 'chat_scripts_cubit.dart';

enum ChatScriptsStatus {
  initial,
  loading,
  updated,
  waitingForAnswer,
  error,
}

class ChatScriptsState extends Equatable {
  const ChatScriptsState({
    required this.status,
    required this.chatHistory,
    required this.currentConditionalItem,
    required this.gainedAnswer,
    required this.availableChat,
    this.error = '',
  });

  const ChatScriptsState.initial()
      : status = ChatScriptsStatus.initial,
        chatHistory = const ChatScriptItem.empty(),
        currentConditionalItem = const ChatScriptItem.empty(),
        gainedAnswer = const ChatScriptItem.empty(),
        availableChat = const ChatScriptItem.empty(),
        error = '';

  final ChatScriptsStatus status;
  final ChatScriptItem chatHistory;
  final ChatScriptItem currentConditionalItem;
  final ChatScriptItem gainedAnswer;
  final ChatScriptItem availableChat;

  final String error;

  bool get hasAvailableChat => availableChat != const ChatScriptItem.empty();

  @override
  List<Object> get props {
    return [
      status,
      chatHistory,
      currentConditionalItem,
      gainedAnswer,
      availableChat,
      error,
    ];
  }

  ChatScriptsState copyWith({
    ChatScriptsStatus? status,
    ChatScriptItem? chatHistory,
    ChatScriptItem? currentConditionalItem,
    ChatScriptItem? gainedAnswer,
    ChatScriptItem? availableChat,
    String? error,
  }) {
    return ChatScriptsState(
      status: status ?? this.status,
      chatHistory: chatHistory ?? this.chatHistory,
      currentConditionalItem:
          currentConditionalItem ?? this.currentConditionalItem,
      gainedAnswer: gainedAnswer ?? this.gainedAnswer,
      availableChat: availableChat ?? this.availableChat,
      error: error ?? this.error,
    );
  }
}
